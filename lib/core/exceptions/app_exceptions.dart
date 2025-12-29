/// Custom exception classes for MyLift app.

/// Base exception class for all app exceptions.
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalException;

  const AppException({
    required this.message,
    this.code,
    this.originalException,
  });

  @override
  String toString() => 'AppException: $message (code: $code)';
}

/// Authentication related exceptions.
class AuthException extends AppException {
  const AuthException({
    required super.message,
    super.code,
    super.originalException,
  });

  factory AuthException.invalidEmail() => const AuthException(
        message: 'The email address is not valid.',
        code: 'invalid-email',
      );

  factory AuthException.userDisabled() => const AuthException(
        message: 'This account has been disabled.',
        code: 'user-disabled',
      );

  factory AuthException.userNotFound() => const AuthException(
        message: 'No account found with this email.',
        code: 'user-not-found',
      );

  factory AuthException.wrongPassword() => const AuthException(
        message: 'Incorrect password.',
        code: 'wrong-password',
      );

  factory AuthException.emailAlreadyInUse() => const AuthException(
        message: 'An account already exists with this email.',
        code: 'email-already-in-use',
      );

  factory AuthException.weakPassword() => const AuthException(
        message: 'Password is too weak. Please use a stronger password.',
        code: 'weak-password',
      );

  factory AuthException.operationNotAllowed() => const AuthException(
        message: 'This sign-in method is not enabled.',
        code: 'operation-not-allowed',
      );

  factory AuthException.tooManyRequests() => const AuthException(
        message: 'Too many attempts. Please try again later.',
        code: 'too-many-requests',
      );

  factory AuthException.unknown([dynamic originalException]) => AuthException(
        message: 'An unknown error occurred. Please try again.',
        code: 'unknown',
        originalException: originalException,
      );

  /// Create from Firebase error code.
  factory AuthException.fromCode(String code, [dynamic originalException]) {
    switch (code) {
      case 'invalid-email':
        return AuthException.invalidEmail();
      case 'user-disabled':
        return AuthException.userDisabled();
      case 'user-not-found':
        return AuthException.userNotFound();
      case 'wrong-password':
        return AuthException.wrongPassword();
      case 'email-already-in-use':
        return AuthException.emailAlreadyInUse();
      case 'weak-password':
        return AuthException.weakPassword();
      case 'operation-not-allowed':
        return AuthException.operationNotAllowed();
      case 'too-many-requests':
        return AuthException.tooManyRequests();
      default:
        return AuthException.unknown(originalException);
    }
  }
}

/// Firestore database exceptions.
class DatabaseException extends AppException {
  const DatabaseException({
    required super.message,
    super.code,
    super.originalException,
  });

  factory DatabaseException.notFound(String resource) => DatabaseException(
        message: '$resource not found.',
        code: 'not-found',
      );

  factory DatabaseException.permissionDenied() => const DatabaseException(
        message: 'You do not have permission to access this resource.',
        code: 'permission-denied',
      );

  factory DatabaseException.unavailable() => const DatabaseException(
        message: 'Service is currently unavailable. Please try again later.',
        code: 'unavailable',
      );

  factory DatabaseException.unknown([dynamic originalException]) =>
      DatabaseException(
        message: 'A database error occurred. Please try again.',
        code: 'unknown',
        originalException: originalException,
      );
}

/// Network related exceptions.
class NetworkException extends AppException {
  const NetworkException({
    required super.message,
    super.code,
    super.originalException,
  });

  factory NetworkException.noConnection() => const NetworkException(
        message: 'No internet connection. Please check your network.',
        code: 'no-connection',
      );

  factory NetworkException.timeout() => const NetworkException(
        message: 'Connection timed out. Please try again.',
        code: 'timeout',
      );

  factory NetworkException.serverError() => const NetworkException(
        message: 'Server error. Please try again later.',
        code: 'server-error',
      );

  factory NetworkException.unknown([dynamic originalException]) =>
      NetworkException(
        message: 'A network error occurred. Please try again.',
        code: 'unknown',
        originalException: originalException,
      );
}

/// AI/Gemini related exceptions.
class AIException extends AppException {
  const AIException({
    required super.message,
    super.code,
    super.originalException,
  });

  factory AIException.generationFailed() => const AIException(
        message: 'Failed to generate response. Please try again.',
        code: 'generation-failed',
      );

  factory AIException.quotaExceeded() => const AIException(
        message: 'AI quota exceeded. Please try again later.',
        code: 'quota-exceeded',
      );

  factory AIException.invalidResponse() => const AIException(
        message: 'Received invalid response from AI.',
        code: 'invalid-response',
      );

  factory AIException.unknown([dynamic originalException]) => AIException(
        message: 'An AI error occurred. Please try again.',
        code: 'unknown',
        originalException: originalException,
      );
}

/// Validation exceptions.
class ValidationException extends AppException {
  final Map<String, String>? fieldErrors;

  const ValidationException({
    required super.message,
    super.code,
    this.fieldErrors,
    super.originalException,
  });

  factory ValidationException.invalidInput(String field, String error) =>
      ValidationException(
        message: error,
        code: 'invalid-input',
        fieldErrors: {field: error},
      );

  factory ValidationException.multipleErrors(Map<String, String> errors) =>
      ValidationException(
        message: 'Please fix the errors below.',
        code: 'multiple-errors',
        fieldErrors: errors,
      );
}

/// Cache/storage exceptions.
class CacheException extends AppException {
  const CacheException({
    required super.message,
    super.code,
    super.originalException,
  });

  factory CacheException.readFailed() => const CacheException(
        message: 'Failed to read from cache.',
        code: 'read-failed',
      );

  factory CacheException.writeFailed() => const CacheException(
        message: 'Failed to write to cache.',
        code: 'write-failed',
      );

  factory CacheException.notFound() => const CacheException(
        message: 'Item not found in cache.',
        code: 'not-found',
      );
}
