class Failure {
  final String? message;
  final int? statusCode;
  final dynamic data;

  Failure({this.message, this.statusCode, this.data});

  @override
  String toString() => message!;
}
