import 'dart:async';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:palette_generator/palette_generator.dart';

class PalletServices {
  static Future<Color?> getDominantColorFromPallet(Uint8List image) async {
    final complete = Completer();
    final receiver = ReceivePort();
    Isolate? isolate;
    receiver.listen((message) {
      isolate?.kill();
      if (message is Color) {
        complete.complete(message);
      } else {
        complete.complete(null);
      }
    });
    isolate = await Isolate.spawn(_getPallet, {
      'sender': receiver.sendPort,
      'provider': image,
    });
    return await complete.future;
  }
}

void _getPallet(Map message) {
  final sender = (message['sender'] as SendPort);
  final provider = message['provider'] as Uint8List;

  final response = PaletteGenerator.fromImageProvider(MemoryImage(provider),
          maximumColorCount: 5, timeout: Duration(seconds: 3))
      .then((value) {
    sender.send(value.dominantColor?.color);
  });
}
