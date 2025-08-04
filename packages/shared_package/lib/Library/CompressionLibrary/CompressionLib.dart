import 'dart:typed_data';
import 'package:archive/archive.dart' ;

class CompressionLib {

  Uint8List? compressBlob(Uint8List blob) {

    final encoder = ZLibEncoder();
    return encoder.encodeBytes(blob);
  }

  Uint8List decompressBlob(Uint8List compressedBlob) {
    final decoder = ZLibDecoder();
    return decoder.decodeBytes(compressedBlob);
  }
}