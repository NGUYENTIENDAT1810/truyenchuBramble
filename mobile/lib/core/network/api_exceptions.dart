class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, [this.statusCode]);

  @override
  String toString() => message;
}

class NetworkException extends ApiException {
  NetworkException([String message = 'No internet connection or server unreachable'])
      : super(message, 0);
}

class UnauthorizedException extends ApiException {
  UnauthorizedException([String message = 'Session expired, please login again'])
      : super(message, 401);
}

class ForbiddenException extends ApiException {
  ForbiddenException([String message = 'Access denied']) : super(message, 403);
}

class NotFoundException extends ApiException {
  NotFoundException([String message = 'Resource not found']) : super(message, 404);
}

class ServerException extends ApiException {
  ServerException([String message = 'Internal server error']) : super(message, 500);
}
