class AppException implements Exception {
  final String message;

  AppException(this.message);
}

class ConnectionFailedException extends AppException {
  ConnectionFailedException({ String message = 'Tidak dapat terhubung dengan server. Harap periksa kembali koneksi internet Anda.' }): super(message);
}

class BadRequestException extends AppException {
  BadRequestException({ String message = 'Tidak dapat memproses data. Data yang dikirimkan tidak sesuai.' }): super(message);
}

class UnauthenticatedException extends AppException {
  UnauthenticatedException({ String message = 'Kredensial yang Anda masukkan tidak sesuai. Silahkan login kembali.' }): super(message);
}

class ForbiddenException extends AppException {
  ForbiddenException({ String message = 'Anda tidak memiliki akses untuk resource ini.' }): super(message);
}

class NotFoundException extends AppException {
  NotFoundException({ String message = 'Resource yang Anda minta tidak ditemukan.' }): super(message);
}

class ConflictException extends AppException {
  ConflictException({ String message = 'Terjadi konflik pada resource.' }): super(message);
}

class UnprocessableEntityException extends AppException {
  UnprocessableEntityException({ String message = 'Tidak dapat memproses data. Data yang dikirimkan tidak sesuai.' }): super(message);
}

class TooManyRequestException extends AppException {
  TooManyRequestException({ String message = 'Tidak dapat memproses permintaan Anda untuk sementara waktu.' }): super(message);
}

class ServerErrorException extends AppException {
  ServerErrorException({ String message = 'Terjadi kesalahan pada sistem kami. Silahkan kembali lagi nanti.' }): super(message);
}
