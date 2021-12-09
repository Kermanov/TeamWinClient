class ApplicationException implements Exception {
  String message;
  Exception innerException;

  ApplicationException([this.message, this.innerException]);

  @override
  String toString() {
    return "${this.runtimeType}($message)";
  }
}
