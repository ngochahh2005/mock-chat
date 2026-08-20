import 'package:base_bloc_3/features/authen/domain/repository/authen_repository.dart';
import 'package:base_bloc_3/import.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
          BaseError.httpUnknownError(
            'Vui lòng xác thực email để đăng nhập!',
          ),
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
        errorMessage = 'Email này đã được sử dụng bởi tài khoản khác!';
        break;
      case 'invalid-email':
        errorMessage = 'Email không hợp lệ!';
        break;
      case 'user-not-found':
        errorMessage = 'Không tìm thấy tài khoản nào với email này!';
        break;
      case 'wrong-password':
        errorMessage = 'Mật khẩu không chính xác!';
        break;
      case 'invalid-credential':
        errorMessage = 'Email hoặc mật khẩu không chính xác!';
        break;
      case 'user-disabled':
        errorMessage = 'Tài khoản đã bị vô hiệu hóa!';
        break;
      case 'too-many-requests':
        errorMessage = 'Bạn đã nhập sai quá nhiều lần. Vui lòng thử lại sau.';
        break;
      case 'network-request-failed':
        errorMessage = 'Lỗi kết nối mạng. Vui lòng kiểm tra lại 3G/Wifi.';
        break;
      case 'channel-error':
        errorMessage = 'Vui lòng nhập đầy đủ email và mật khẩu.';
        break;
      default:
        errorMessage = 'Đăng nhập thất bại. Mã lỗi: (${e.message ?? e.code})';
    }

    return errorMessage;
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
}
