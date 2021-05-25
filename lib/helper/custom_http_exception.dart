class CustomHttpException implements Exception {
  final String _message;
  CustomHttpException(this._message);
  @override
  String toString() {
    return _message;
    // return super.toString();
  }
}
