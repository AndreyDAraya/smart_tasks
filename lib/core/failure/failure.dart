import 'package:equatable/equatable.dart';

class Failure extends Equatable {
  const Failure({required this.code, required this.message});
  final int code;
  final String message;

  factory Failure.fromJson(Map<String, dynamic> json) {
    return Failure(
      code: json['code'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'message': message,
    };
  }

  const Failure.initial()
      : code = 0,
        message = 'Initial Failure';

  @override
  String toString() {
    return "Failure(code: $code, message: $message)";
  }

  @override
  List<Object?> get props => [
        code,
        message,
      ];
}
