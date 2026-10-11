class AppExceptions implements Exception {
  final String? message;
  final String? prefix;

  AppExceptions([this.message, this.prefix]);

  @override
  String toString() {
    return "${prefix ?? ''}${message != null ? ': $message' : ''}";
  }
}

/// Thrown when there is no internet connection available
class InternetException extends AppExceptions {
  InternetException([String? message]) : super(message, 'No Internet Connection');
}

/// Thrown when a network request times out
class RequestTimeOutException extends AppExceptions {
  RequestTimeOutException([String? message]) : super(message, 'Request Time Out');
}

/// Thrown when an internal server error occurs (e.g. 500, 502, 503)
class ServerException extends AppExceptions {
  ServerException([String? message]) : super(message, 'Internal Server Error');
}

/// Thrown when an error occurs during communication with the server
class FetchDataException extends AppExceptions {
  FetchDataException([String? message]) : super(message, 'Error During Communication');
}

/// Thrown when the request is invalid (400 Bad Request)
class BadRequestException extends AppExceptions {
  BadRequestException([String? message]) : super(message, 'Invalid Request');
}

/// Thrown when user is unauthorized or session expired (401, 403)
class UnauthorisedException extends AppExceptions {
  UnauthorisedException([String? message]) : super(message, 'Unauthorised Access');
}

/// Thrown when the requested resource is not found (404)
class NotFoundException extends AppExceptions {
  NotFoundException([String? message]) : super(message, 'Resource Not Found');
}
