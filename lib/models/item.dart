import 'dart:io';

class Item {
  final String nomeDoItem;
  final double quantidade;
  final File? imagem;

  Item({
    required this.nomeDoItem,
    required this.quantidade,
    this.imagem,
  });
}