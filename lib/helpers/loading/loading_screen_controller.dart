import 'package:flutter/foundation.dart';

typedef CloseLoadingScreen = bool Function();
typedef UpdateLoadingScreen = bool Function(String text);

@immutable
class LoadingScreenController {
  final CloseLoadingScreen close;
  final UpdateLoadingScreen update;

  const LoadingScreenController(
    this.close,
    this.update,
  );
}
