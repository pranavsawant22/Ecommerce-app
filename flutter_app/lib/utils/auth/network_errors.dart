class AppException implements Exception {
  final _message;
  final _prefix;

  AppException([this._message, this._prefix]);

  @override
  String toString() {
    return "$_prefix$_message";
  }
}

class FetchDataException extends AppException {
  FetchDataException([message])
      : super(message, "Error During Communication:\n");
}

class BadRequestException extends AppException {
  BadRequestException([message]) : super(message, "Invalid Request: ");
}

class UnauthorisedException extends AppException {
  UnauthorisedException([message]) : super(message, "Unauthorised: ");
}

class InvalidInputException extends AppException {
  InvalidInputException([message]) : super(message, "Invalid Input: ");
}

class ConflictException extends AppException {
  ConflictException([message]) : super(message, "Conflict: ");
}

class NotAcceptableException extends AppException {
  NotAcceptableException([message]) : super(message, "Not Acceptable: ");
}

class RequestTimeoutException extends AppException {
  RequestTimeoutException([message]) : super(message, "Request Timeout: ");
}

class InternalServerException extends AppException {
  InternalServerException([message]) : super(message, "Internal Server Error: ");
}

class BadGatewayException extends AppException {
  BadGatewayException([message]) : super(message, "Bad Gateway: ");
}
