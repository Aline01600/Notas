# Notas
Este é um aplicativo de notas simples, desenvolvido em Flutter, que demonstra a implementação da persistência de dados utilizando o SharedPreferences. O aplicativo permite que o usuário adicione, visualize, edite e exclua notas, salvando todas as alterações no dispositivo para que os dados não sejam perdidos.

# Temas abordados
Persistência de Dados com SharedPreferences: A principal funcionalidade do aplicativo é a utilização do shared_preferences para armazenar as notas de forma local no dispositivo.

As notas são salvas em formato JSON, garantindo que os dados sejam estruturados e fáceis de carregar e salvar.

As funções _carregarNotas() e _salvarNotas() na classe _NotasPageState são responsáveis por ler e escrever os dados no armazenamento local, respectivamente.

Manipulação de Estado (State Management): O estado da lista de notas é gerenciado pela classe _NotasPageState, que é atualizada sempre que uma nota é adicionada, editada ou removida.

Navegação: O aplicativo utiliza Navigator.of(context).push() para navegar entre a tela principal (NotasPage) e a tela de edição (EdicaoNotaPage).

Componentes de UI e Interação:

ListView.builder: Constrói uma lista dinâmica e eficiente para exibir as notas.

Dismissible: Permite que o usuário remova uma nota da lista com um gesto de deslizar, oferecendo uma interação intuitiva.

AlertDialog: Utilizado para confirmar a exclusão de uma nota, evitando ações acidentais.