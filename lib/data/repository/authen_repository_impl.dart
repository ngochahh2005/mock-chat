import 'package:base_bloc_3/features/authen/domain/repository/authen_repository.dart';
import 'package:base_bloc_3/import.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

@LazySingleton(as: AuthenRepository)
class AuthenRepositoryImpl implements AuthenRepository {
  final _auth = FirebaseAuth.instance;
  final _storage = SecureStorageService();
  final _firestore = FirebaseFirestore.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  @override
  Future<Either<BaseError, String>> login(
    String email,
    String password,
  ) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user != null && !user.emailVerified) {
        await _auth.signOut();
        return Left(
          BaseError.httpUnknownError(S.current.verify_email_to_login),
        );
      }

      final token = await credential.user?.getIdToken() ?? '';
      return Right(token);
    } on FirebaseException catch (e) {
      return Left(BaseError.httpUnknownError(_handleException(e)));
    } catch (e) {
      return Left(BaseError.httpUnknownError(e.toString()));
    }
  }

  @override
  Future<Either<BaseError, void>> register(
    String email,
    String password,
    String username,
  ) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _firestore.collection('users').doc(credential.user!.uid).set({
        'uid': credential.user!.uid,
        'email': email,
        'username': username,
        'createdAt': FieldValue.serverTimestamp(),
      });

      await _sendEmailVerification();
      await _auth.signOut();
      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(BaseError.httpUnknownError(_handleException(e)));
    } catch (e) {
      return Left(BaseError.httpUnknownError(e.toString()));
    }
  }

  @override
  Future<Either<BaseError, void>> logout() async {
    try {
      await _storage.clearToken();
      await _auth.signOut();
      return const Right(null);
    } catch (e) {
      return Left(BaseError.httpUnknownError(e.toString()));
    }
  }

  @override
  Future<Either<BaseError, Map<String, dynamic>>> fetchProfile() async {
    try {
      final user = _auth.currentUser;
      if (user == null)
        return Left(BaseError.httpUnknownError(S.current.not_logged_in));

      final doc = await _firestore.collection('users').doc(user.uid).get();

      if (doc.exists && doc.data() != null) {
        return Right(doc.data()!);
      } else {
        return Left(BaseError.httpUnknownError(S.current.user_info_not_found));
      }
    } catch (e) {
      return Left(BaseError.httpUnknownError(e.toString()));
    }
  }

  @override
  Future<Either<BaseError, void>> updateProfile(
    String? username,
    File? avatarFile,
    String? displayName,
  ) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return Left(BaseError.httpUnknownError(S.current.not_logged_in));
      }

      String? photoUrl;
      
      if (avatarFile != null) {
        final dio = Dio();
        final formData = FormData.fromMap({
          'key': '766bea844fd5bf5427a83cb087dd6c74',
          'image': await MultipartFile.fromFile(avatarFile.path),
        });
        final resp = await dio.post('https://api.imgbb.com/1/upload', data: formData);

        if (resp.statusCode == 200) {
          photoUrl = resp.data['data']['url'];
          await user.updatePhotoURL(photoUrl);
        }
      }

      if (displayName != null) await user.updateDisplayName(displayName);

      Map<String, dynamic> updateData = {};

      if (username != null) updateData['username'] = username;
      if (photoUrl != null) updateData['avatar'] = photoUrl;

      if (updateData.isNotEmpty) {
        await _firestore.collection('users').doc(user.uid).set(updateData, SetOptions(merge: true));
      }
      return const Right(null);
    } catch (e) {
      return Left(BaseError.httpUnknownError(e.toString()));
    }
  }

  Future<void> _sendEmailVerification() async {
    final user = _auth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  String _handleException(FirebaseException e) {
    String errorMessage = '';
    switch (e.code) {
      case 'email-already-in-use':
        errorMessage = S.current.email_already_in_use;
        break;
      case 'invalid-email':
        errorMessage = S.current.invalid_email;
        break;
      case 'user-not-found':
        errorMessage = S.current.user_not_found;
        break;
      case 'wrong-password':
        errorMessage = S.current.wrong_password;
        break;
      case 'invalid-credential':
        errorMessage = S.current.invalid_credential;
        break;
      case 'user-disabled':
        errorMessage = S.current.user_disabled;
        break;
      case 'too-many-requests':
        errorMessage = S.current.too_many_requests;
        break;
      case 'network-request-failed':
        errorMessage = S.current.network_request_failed;
        break;
      case 'channel-error':
        errorMessage = S.current.channel_error;
        break;
      default:
        errorMessage = '${S.current.error_message} (${e.message ?? e.code})';
    }

    return errorMessage;
  }
}
