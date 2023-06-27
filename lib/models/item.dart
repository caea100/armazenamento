import 'dart:io';
import 'dart:typed_data';

class Item {
  final String nomeDoItem;
  final double quantidade;
  final File? imagem;
    final Uint8List? imagemBytes;

  Item({
    required this.nomeDoItem,
    required this.quantidade,
    this.imagem,
        this.imagemBytes,
  });
}