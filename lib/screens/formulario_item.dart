
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';

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
  late File? _image;

  @override
  void initState() {
    super.initState();
    _controllerCampoNomeItem = TextEditingController(
      text: widget.item != null ? widget.item!.nomeDoItem : '',
    );
    _controllerCampoQuantidade = TextEditingController(
      text: widget.item != null ? widget.item!.quantidade.toString() : '',
    );
    _image = widget.item?.imagem;
  }

  Future<void> _pickImage(ImageSource source) async {
    PermissionStatus status = await Permission.storage.request();
    if (status.isGranted) {
      try {
        final image = await ImagePicker().pickImage(source: source);
        if (image == null) return;
        File? img = File(image.path);
        setState(() {
          _image = img;
        });
      } on PlatformException catch (e) {
        print(e);
      }
    } else {
      if (status.isPermanentlyDenied) {
        openAppSettings();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('A permissão para acessar a galeria foi negada.'),
          ),
        );
      }
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
                onPressed: () {
                  _pickImage(ImageSource.gallery);
                },
                child: const Text('Selecionar Imagem'),
              ),
              if (_image != null) Image.file(_image!),
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
                        imagem: _image,
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