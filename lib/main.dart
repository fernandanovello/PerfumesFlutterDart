import 'package:flutter/material.dart';
import 'dart:async';

// Desenvolvido por Fernanda de Souza Batista Santos
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catálogo de Produtos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  late Timer _timer;

  final List<Product> products = [
    Product('Devotion', 'Dolce&Gabbana Perfume Feminino Eau De Parfum - 100ml',
        'assets/images/devotion.png', 879.99),
    Product('Perfume K Eau de Parfum', 'Dolce & Gabbana - Masculino - 50ml',
        'assets/images/dolcegabbana.jpg', 599.99),
    Product('The Only One 2 Feminino', 'Dolce & Gabbana Eau de Parfum - 50ml',
        'assets/images/theonlyone.png', 519.99),
    Product(
        'Olympéa Solar Feminino',
        'Paco Rabanne Perfume Eau de Parfum - 80ml',
        'assets/images/olympea.png',
        769.99),
    Product(
        'PERFUME DOLCE&GABBANA THE ONE',
        'FOR MEN INTENSE MASCULINO EAU DE PARFUM - 100ml',
        'assets/images/theone.png',
        849.99),
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      if (_scrollController.hasClients) {
        final maxScroll = _scrollController.position.maxScrollExtent;
        final currentScroll = _scrollController.position.pixels;
        final scrollPosition = currentScroll +
            MediaQuery.of(context).size.width *
                0.5; // Movendo 80% da largura da tela
        if (scrollPosition >= maxScroll) {
          _scrollController.animateTo(
            0.0,
            duration: Duration(milliseconds: 800),
            curve: Curves.easeInOut,
          );
        } else {
          _scrollController.animateTo(
            scrollPosition,
            duration: Duration(milliseconds: 800),
            curve: Curves.easeInOut,
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Catálogo de Produtos'),
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            color: Colors.blue[100], // Um leve fundo azul para destaque
            width: double.infinity, // Ocupa toda a largura disponível
            child: Text(
              'Desenvolvido por: Fernanda de Souza Batista Santos.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800] // Cor mais escura para o texto
                  ),
            ),
          ),
          Expanded(
            // Use Expanded para preencher o espaço restante com o ListView
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              controller: _scrollController,
              itemCount: products.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            DetailPage(product: products[index])),
                  ),
                  child: Container(
                    width: MediaQuery.of(context).size.width *
                        0.8, // Cada item ocupa 80% da largura da tela
                    child: Card(
                      child: Column(
                        children: <Widget>[
                          Expanded(
                              child: Image.asset(products[index].image,
                                  fit: BoxFit
                                      .cover)), // Imagem cobrindo mais espaço
                          Text(products[index].name),
                          Text(
                              'R\$${products[index].price.toStringAsFixed(2)}'),
                        ],
                      ),
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

class Product {
  final String name;
  final String description;
  final String image;
  final double price;

  Product(this.name, this.description, this.image, this.price);
}

class DetailPage extends StatelessWidget {
  final Product product;

  DetailPage({required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
      ),
      body: SingleChildScrollView(
        // Adicionado para permitir rolagem se necessário
        child: Column(
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width *
                  0.8, // 80% da largura da tela
              child: Image.asset(product.image, fit: BoxFit.contain),
            ),
            Padding(
              padding: const EdgeInsets.all(
                  8.0), // Adiciona um padding para melhor visualização
              child: Text(product.name, style: TextStyle(fontSize: 24)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(product.description),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('R\$${product.price.toStringAsFixed(2)}'),
            ),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Compra realizada: R\$${product.price.toStringAsFixed(2)}'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: Text('Comprar'),
            ),
          ],
        ),
      ),
    );
  }
}
