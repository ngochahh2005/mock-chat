import 'package:base_bloc_3/common/external_lib.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@lazySingleton
class SupabaseStorageService {
  SupabaseStorageService();
  final SupabaseClient _client = Supabase.instance.client;
  static const String bucketName = 'chat_media';
  static const String stickerBucketName = 'chat-assets';

  Future<List<String>> listStickerPaths({String folder = 'stickers'}) async {
    final paths = <String>[];

    Future<void> visit(String currentFolder) async {
      final objects = await _client.storage.from(stickerBucketName).list(
            path: currentFolder,
            searchOptions: const SearchOptions(limit: 1000),
          );
      for (final object in objects) {
        final path = '$currentFolder/${object.name}';
        if (_isStickerFile(object.name)) {
          paths.add(path);
        } else if (object.id == null || !object.name.contains('.')) {
          // Folder FileObjects are represented differently between storage
          // API versions, so also recognize folder names without extensions.
          await visit(path);
        }
      }
    }

    await visit(folder);
    paths.sort();
    return paths;
  }

  Future<Map<String, List<String>>> listStickerSets() async {
    final root = await _client.storage.from(stickerBucketName).list(
          path: 'stickers',
          searchOptions: const SearchOptions(limit: 1000),
        );
    final sets = <String, List<String>>{};

    for (final object in root) {
      if (_isStickerFile(object.name)) {
        sets.putIfAbsent('Tất cả', () => []).add('stickers/${object.name}');
      } else if (object.id == null || !object.name.contains('.')) {
        final path = 'stickers/${object.name}';
        sets[object.name] = await listStickerPaths(folder: path);
      }
    }

    if (sets.containsKey('Tất cả')) {
      final all = <String>[];
      for (final paths in sets.values) {
        all.addAll(paths);
      }
      sets['Tất cả'] = all.toSet().toList()..sort();
    }
    return sets..removeWhere((_, paths) => paths.isEmpty);
  }

  bool _isStickerFile(String name) => const {
        'png',
        'gif',
        'webp',
        'jpg',
        'jpeg',
      }.contains(name.split('.').last.toLowerCase());

  String getStickerUrl(String stickerPath) =>
      _client.storage.from(stickerBucketName).getPublicUrl(stickerPath);

  // upload picture
  Future<String?> uploadChatImage({
    required XFile image,
    required String roomId,
    required String senderUid,
  }) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) throw Exception('Chưa đăng nhập Firebase!');

    final extension = image.name.contains('.') ? image.name.split('.').last.toLowerCase() : 'jpg';
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.$extension';
    final storagePath = '$roomId/${currentUser.uid}/$fileName';
    final file = File(image.path);

    await _client.storage.from(bucketName).upload(storagePath, file);
    return storagePath;
  }

  String getImageUrl(String storagePath) {
    return _client.storage.from(bucketName).getPublicUrl(storagePath);
  }

  Future<void> deleteImage(String storagePath) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    await _client.storage.from(bucketName).remove([storagePath]);
  }
}
