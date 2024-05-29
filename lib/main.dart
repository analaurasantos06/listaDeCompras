import 'package:flutter/material.dart';

void main() {
  runApp(ComprasDeMercado());
}

class Item {
  String nome;
  String categoria;
  double precoMaximo;

  Item(
      {required this.nome, required this.categoria, required this.precoMaximo});
}

class ComprasDeMercado extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Compras De Mercado',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
// Adiciona a imagem do logo
                Image.asset(
                  'img/logo.png',
                  height: 244,
                  width: 275,
                ),
              ],
            ),
            SizedBox(height: 20),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Usuário'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
// Verificar credenciais
                if (_usernameController.text == 'Compra' &&
                    _passwordController.text == 'compra123') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ShoppingListPage()),
                  );
                } else {
// Exibir mensagem de erro
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Credenciais inválidos')),
                  );
                }
              },
              child: Text('Login'),
            ),
            Text('Ana Laura')
          ],
        ),
      ),
    );
  }
}

class ShoppingListPage extends StatefulWidget {
  @override
  _ShoppingListPageState createState() => _ShoppingListPageState();
}

class _ShoppingListPageState extends State<ShoppingListPage> {
// Lista de itens (simulando um banco de dados)
  List<Item> items = [];

  final List<String> categoriasValidas = [
    'Frutas',
    'Legumes',
    'Padaria',
    'Bebidas',
    'Limpeza',
    'Açougue'
  ];

  TextEditingController _nomeController = TextEditingController();
  TextEditingController _categoriaController = TextEditingController();
  TextEditingController _precoController = TextEditingController();

// Variáveis de estado para edição
  int? _editingIndex;
  bool _isEditing = false;

  void _adicionarItem() {
    if (_nomeController.text.isNotEmpty &&
        _categoriaController.text.isNotEmpty &&
        categoriasValidas.contains(_categoriaController.text) &&
        double.tryParse(_precoController.text) != null) {
      setState(() {
        items.add(Item(
          nome: _nomeController.text.trim(),
          categoria: _categoriaController.text.trim(),
          precoMaximo: double.parse(_precoController.text.trim()),
        ));
      });
      _limparCampos();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Item adicionado')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Preencha todos os campos corretamente')),
      );
    }
  }

  void _editarItem(int index) {
    if (_nomeController.text.isNotEmpty &&
        _categoriaController.text.isNotEmpty &&
        categoriasValidas.contains(_categoriaController.text) &&
        double.tryParse(_precoController.text) != null) {
      setState(() {
        items[index] = Item(
          nome: _nomeController.text.trim(),
          categoria: _categoriaController.text.trim(),
          precoMaximo: double.parse(_precoController.text.trim()),
        );
      });
      _limparCampos();
      _isEditing = false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Item atualizado')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Preencha todos os campos corretamente')),
      );
    }
  }

  void _removerItem(int index) {
    setState(() {
      items.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Item removido')),
    );
  }

  void _limparCampos() {
    _nomeController.clear();
    _categoriaController.clear();
    _precoController.clear();
    _isEditing = false;
    _editingIndex = null;
  }

  void _iniciarEdicao(int index) {
    setState(() {
      _nomeController.text = items[index].nome;
      _categoriaController.text = items[index].categoria;
      _precoController.text = items[index].precoMaximo.toString();
      _isEditing = true;
      _editingIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Compras'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nomeController,
              decoration: InputDecoration(labelText: 'Nome'),
            ),
            TextField(
              controller: _categoriaController,
              decoration: InputDecoration(labelText: 'Categoria'),
            ),
            TextField(
              controller: _precoController,
              decoration: InputDecoration(labelText: 'Preço Máximo'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _isEditing
                  ? () => _editarItem(_editingIndex!)
                  : _adicionarItem,
              child: Text(_isEditing ? 'Salvar' : 'Adicionar'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(items[index].nome),
                    subtitle: Text(
                        '${items[index].categoria}R\$ ${items[index].precoMaximo.toStringAsFixed(2)}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            _iniciarEdicao(index);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            _removerItem(index);
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
