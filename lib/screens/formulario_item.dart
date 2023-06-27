import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'dart:typed_data';

import '../models/item.dart';

class FormularioItem extends StatefulWidget {
  final void Function(Item) adicionarItem;
  final Item? item;

  const FormularioItem({
    Key? key,
    required this.adicionarItem,
    this.item,
  }) : super(key: key);

  @override
  _FormularioItemState createState() => _FormularioItemState();
}

class _FormularioItemState extends State<FormularioItem> {
  late TextEditingController _controllerCampoNomeItem;
  late TextEditingController _controllerCampoQuantidade;
  Uint8List? _imageBytes;

  @override
  void initState() {
    super.initState();
    _controllerCampoNomeItem = TextEditingController(
      text: widget.item != null ? widget.item!.nomeDoItem : '',
    );
    _controllerCampoQuantidade = TextEditingController(
      text: widget.item != null ? widget.item!.quantidade.toString() : '',
    );
    _imageBytes = widget.item?.imagemBytes;
  }

  Future<void> _pickImage() async {
    try {
      final html.InputElement? input = (html.document.createElement('input') as html.InputElement)
        ..type = 'file'
        ..accept = 'image/*';

      input?.click();

      input?.onChange.listen((event) async {
        final files = input?.files;
        if (files != null && files.isNotEmpty) {
          final reader = html.FileReader();
          reader.readAsDataUrl(files[0]);
          reader.onLoadEnd.listen((event) {
            final base64Data = reader.result.toString().split(',').last;
            setState(() {
              _imageBytes = base64Decode(base64Data);
            });
          });
        }
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modificando Item'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text('Selecionar Imagem'),
              ),
              if (_imageBytes != null)
                Image.memory(
                  _imageBytes!,
                  fit: BoxFit.cover,
                ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: _controllerCampoNomeItem,
                  style: const TextStyle(fontSize: 24.0),
                  decoration: const InputDecoration(
                    labelText: 'Nome do item:',
                    hintText: 'Escreva aqui',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: _controllerCampoQuantidade,
                  style: const TextStyle(fontSize: 24.0),
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Quantidade do item:',
                    hintText: '00000',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: ElevatedButton(
                  onPressed: () {
                    final String nomeDoItem = _controllerCampoNomeItem.text;
                    final double quantidade =
                        double.tryParse(_controllerCampoQuantidade.text) ?? 0.0;
                    if (nomeDoItem.isNotEmpty && quantidade > 0) {
                      final novoItem = Item(
                        nomeDoItem: nomeDoItem,
                        quantidade: quantidade,
                        imagemBytes: _imageBytes,
                      );
                      widget.adicionarItem(novoItem);
                      Navigator.of(context).pop();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Insira um nome e uma quantidade.'),
                        ),
                      );
                    }
                  },
                  child: const Text(
                    'Salvar',
                    style: TextStyle(fontSize: 24.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
