import 'package:armazenamento/screens/formulario_item.dart';
import 'package:flutter/material.dart';

import '../models/item.dart';


class ListaItem extends StatefulWidget {
  const ListaItem({Key? key}) : super(key: key);

  @override
  _ListaItemState createState() => _ListaItemState();
}

class _ListaItemState extends State<ListaItem> {
  List<Item> listaDeItens = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estoque'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FormularioItem(
                adicionarItem: (Item novoItem) {
                  setState(
                    () {
                      listaDeItens.add(novoItem);
                    },
                  );
                },
              ),
            ),
          );
        },
        label: const Text('Adicionar Item'),
        icon: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: listaDeItens.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FormularioItem(
                    adicionarItem: (Item novoItem) {
                      setState(
                        () {
                          listaDeItens[index] = novoItem;
                        },
                      );
                    },
                    item: listaDeItens[index],
                  ),
                ),
              );
            },
            child: Card(
              child: ListTile(
                leading: listaDeItens[index].imagem != null
                    ? CircleAvatar(
                        backgroundImage: FileImage(listaDeItens[index].imagem!),
                      )
                    : const Icon(Icons.stop),
                title: Text(listaDeItens[index].nomeDoItem),
                subtitle: Text(listaDeItens[index].quantidade.toString()),
              ),
            ),
          );
        },
      ),
    );
  }
}
