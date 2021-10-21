import 'dart:async';

import 'package:flutter/services.dart';

class DeepLinkChannel {
  DeepLinkChannel._() {
    _initlistenUrl();
  }
  static DeepLinkChannel get instance => DeepLinkChannel._();

  final _channel = MethodChannel('deep_link_ios');
  final _streamController = StreamController<String>.broadcast();

  Stream<String> get stream => _streamController.stream;

  /// user for listen urls in deep-link
  _initlistenUrl() {
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'url_received') {
        _streamController.add(call.arguments['url']);
      }
    });
  }
}
