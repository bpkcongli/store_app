class UserRegistrationInvalidStateException implements Exception {
  final String cause;

  UserRegistrationInvalidStateException(this.cause);
}
