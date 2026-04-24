import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ShareCardService {
  const ShareCardService();

  Future<void> shareRepaintBoundary({
    required RenderRepaintBoundary boundary,
    required String fileName,
    required String text,
  }) async {
    final image = await boundary.toImage(pixelRatio: 3);

    final byteData = await image.toByteData(
      format: ui.ImageByteFormat.png,
    );

    if (byteData == null) {
      throw Exception('Não foi possível converter o widget em imagem.');
    }

    final Uint8List pngBytes = byteData.buffer.asUint8List();

    final tempDir = await getTemporaryDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final file = File('${tempDir.path}/${timestamp}_$fileName');

    await file.writeAsBytes(pngBytes, flush: true);

    await SharePlus.instance.share(
      ShareParams(
        text: text,
        files: [XFile(file.path)],
      ),
    );
  }
}