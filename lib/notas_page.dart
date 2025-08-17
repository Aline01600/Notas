import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'edicao_nota_page.dart'; // Importa a tela de edição

// Define a classe Nota para armazenar o título e o conteúdo
class Nota {
  String titulo;
  String conteudo;

  Nota({required this.titulo, this.conteudo = ''});

  // Converte um objeto Nota em um mapa (para salvar no SharedPreferences)
  Map<String, dynamic> toJson() {
    return {'titulo': titulo, 'conteudo': conteudo};
  }

  // Cria um objeto Nota a partir de um mapa (para carregar do SharedPreferences)
  factory Nota.fromJson(Map<String, dynamic> json) {
    return Nota(titulo: json['titulo'], conteudo: json['conteudo']);
  }
}

class NotasPage extends StatefulWidget {
  const NotasPage({Key? key}) : super(key: key);

  @override
  State<NotasPage> createState() => _NotasPageState();
}

class _NotasPageState extends State<NotasPage> {
  final TextEditingController _controller = TextEditingController();
  List<Nota> _notas = [];
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _carregarNotas();
  }

  // Carrega as notas do SharedPreferences
  _carregarNotas() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      String? notasJson = _prefs.getString('notas_json');
      if (notasJson != null) {
        List<dynamic> notasDecoded = json.decode(notasJson);
        _notas = notasDecoded.map((item) => Nota.fromJson(item)).toList();
      }
    });
  }

  // Salva as notas no SharedPreferences
  _salvarNotas() async {
    String notasEncoded = json.encode(
      _notas.map((nota) => nota.toJson()).toList(),
    );
    await _prefs.setString('notas_json', notasEncoded);
  }

  // Adiciona uma nova nota e navega para a tela de edição
  void _adicionarNotaENavegar() {
    String titulo =
        _controller.text.isEmpty ? 'Nota sem título' : _controller.text;
    Nota novaNota = Nota(titulo: titulo);
    setState(() {
      _notas.insert(0, novaNota);
      _controller.clear();
    });
    _salvarNotas();

    // Navega para a tela de edição da nota recém-criada
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) => EdicaoNotaPage(
              nota: novaNota,
              onSave: (notaEditada) {
                //encontra a nota na lista e a atualiza
                setState(() {
                  int index = _notas.indexOf(novaNota);
                  if (index != -1) {
                    _notas[index] = notaEditada;
                  }
                });
                _salvarNotas();
              },
              // Passa a função de exclusão
              onDelete: () {
                setState(() {
                  _notas.remove(novaNota);
                });
                _salvarNotas();
                Navigator.of(context).pop();
              },
            ),
      ),
    );
  }

  // Remove uma nota da lista e salva
  void _removerNota(int index) {
    setState(() {
      _notas.removeAt(index);
    });
    _salvarNotas();
  }

  // Função para confirmar a exclusão da nota por meio de um diálogo
  void _confirmarExclusao(int index) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Excluir Nota?'),
            content: const Text('Tem certeza de que deseja excluir esta nota?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Fecha o diálogo
                },
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  _removerNota(index);
                  Navigator.of(context).pop(); // Fecha o diálogo
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Nota "${_notas[index].titulo}" removida'),
                    ),
                  );
                },
                child: const Text('Excluir'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meu App de Notas')),
      body: Column(
        children: <Widget>[
          // Campo de texto para o título da nota
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'Escreva o título da nota',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (value) => _adicionarNotaENavegar(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(
                    Icons.add_circle,
                    color: Colors.blue,
                    size: 40,
                  ),
                  onPressed: _adicionarNotaENavegar,
                ),
              ],
            ),
          ),
          // Lista de notas
          Expanded(
            child: ListView.builder(
              itemCount: _notas.length,
              itemBuilder: (context, index) {
                // Widget Dismissible para remover a nota com um gesto
                return Dismissible(
                  key: Key(UniqueKey().toString()),
                  onDismissed: (direction) {
                    _removerNota(index);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Nota "${_notas[index].titulo}" removida',
                        ),
                      ),
                    );
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: Card(
                    margin: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 16,
                    ),
                    child: ListTile(
                      title: Text(_notas[index].titulo),
                      // Adiciona a funcionalidade de exclusão por clique longo
                      onLongPress: () => _confirmarExclusao(index),
                      onTap: () {
                        // Navega para a tela de edição da nota selecionada
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder:
                                (context) => EdicaoNotaPage(
                                  nota: _notas[index],
                                  onSave: (notaEditada) {
                                    setState(() {
                                      _notas[index] = notaEditada;
                                    });
                                    _salvarNotas();
                                  },
                                  // Passa a função de exclusão
                                  onDelete: () {
                                    _removerNota(index);
                                    Navigator.of(context).pop();
                                  },
                                ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
