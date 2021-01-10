class NoInternetException {
  var message;
  NoInternetException({this.message = "Check internet connection"});
}

class NoServiceFoundException {
  var message;
  NoServiceFoundException({this.message = "Service not found"});
}

class InvalidFormatException {
  var message;
  InvalidFormatException({this.message = "Invalid data format"});
}

class UnknownException {
  var message;
  UnknownException({this.message = "Unknown error"});
}
