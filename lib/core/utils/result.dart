import 'package:medicationtracker/core/utils/error.dart';

class Result<T> {
  final T? data;
  final CustomError? error;

  Result({this.data, this.error});

  bool get isSuccess => data != null;
}
