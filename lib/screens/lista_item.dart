import 'package:flutter/material.dart';
import 'package:armazenamento/screens/formulario_item.dart';

import '../models/item.dart';

class ListaItem extends StatefulWidget {
  const ListaItem({Key? key}) : super(key: key);

  @override
  _ListaItemState createState() => _ListaItemState();
}

class _ListaItemState extends State<ListaItem> {
  List<Item> listaDeItens = [];
  List<int> itensSelecionados = [];

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
          final item = listaDeItens[index];
          final bool selecionado = itensSelecionados.contains(index);
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
                leading: item.imagemBytes != null
                    ? Image.memory(
                        item.imagemBytes!,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      )
                    : const Icon(Icons.stop),
                title: Text(item.nomeDoItem),
                subtitle: Text(item.quantidade.toString()),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Remover Item'),
                          content: Text('Tem certeza de que deseja remover o item?'),
                          actions: <Widget>[
                            TextButton(
                              child: Text('Cancelar'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: Text('Remover'),
                              onPressed: () {
                                setState(() {
                                  listaDeItens.removeAt(index);
                                });
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
