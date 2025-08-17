import 'package:flutter/material.dart';
import 'notas_page.dart'; // Importa a classe Nota

class EdicaoNotaPage extends StatefulWidget {
  final Nota nota;
  final Function(Nota) onSave;
  final Function() onDelete; // Adiciona um callback para exclusão

  const EdicaoNotaPage({
    Key? key,
    required this.nota,
    required this.onSave,
    required this.onDelete, // O callback para exclusão é agora um parâmetro obrigatório
  }) : super(key: key);

  @override
  State<EdicaoNotaPage> createState() => _EdicaoNotaPageState();
}

class _EdicaoNotaPageState extends State<EdicaoNotaPage> {
  late TextEditingController _tituloController;
  late TextEditingController _conteudoController;

  @override
  void initState() {
    super.initState();
    _tituloController = TextEditingController(text: widget.nota.titulo);
    _conteudoController = TextEditingController(text: widget.nota.conteudo);
  }

  @override
  void dispose() {
    // Salva automaticamente a nota quando a tela é descartada (quando o usuário navega para trás)
    widget.onSave(
      Nota(titulo: _tituloController.text, conteudo: _conteudoController.text),
    );

    _tituloController.dispose();
    _conteudoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Nota'),
        // O botão de salvar foi removido, pois o salvamento agora é automático.
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Campo de texto para o título da nota
            TextField(
              controller: _tituloController,
              decoration: const InputDecoration(
                labelText: 'Título',
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // Campo de texto para o conteúdo da nota
            Expanded(
              child: TextField(
                controller: _conteudoController,
                maxLines: null, // Permite múltiplas linhas
                expands: true, // Expande para preencher o espaço disponível
                decoration: const InputDecoration(
                  labelText: 'Conteúdo da nota',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
