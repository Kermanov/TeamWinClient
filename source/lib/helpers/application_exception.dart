class ApplicationException implements Exception {
  String message;
  Exception innerException;

  ApplicationException([this.message, this.innerException]);
}
