// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';


void main() => runApp(MyApp()); // Metodo principal

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Startup Name Generator', // Titulo que aparece no gerenciador de apps
      theme: ThemeData(          // Tema escuro
        primaryColor: Colors.black,
      ),
      home: RandomWords(), // pagina inicial do app
    );
  }
}

class RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[]; // sugestoes exibidas
  final _biggerFont = const TextStyle(fontSize: 18.0); // estilo do texto
  final Set<WordPair> _saved = Set<WordPair>();   // nomes salvos

  @override
  Widget build(BuildContext context) {
    return Scaffold( // modelo de tela
      appBar: AppBar(
        title: Text('Startup Name Generator'), // nome que aparece na barra
        actions: <Widget>[ // acoes possiveis para a area
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved), // botao com a listinha na barra + acao
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>( // forma simples de criar rotas
        builder: (BuildContext context) {
          final Iterable<ListTile> tiles = _saved.map( // cria um "novo array", usando a funcao passada
                (WordPair pair) {
              return ListTile( // Funcao pro novo array, um list com tamanho de fonte maior + a palavra lida
                title: Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
              );
            },
          );
          final List<Widget> divided = ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList();

          return Scaffold( // cria um novo material
            appBar: AppBar(
              title: Text('Saved Suggestions'),
            ),
            body: ListView(children: divided), // adicionada o conteudo
          );
        },
      ),
    );
  }

  Widget _buildRow(WordPair pair) {
    final bool alreadySaved = _saved.contains(pair);
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: Icon(
        alreadySaved ? Icons.star : Icons.star_border,
        color: alreadySaved ? Colors.amber : null,
      ),
      onTap: () { // acao
        setState(() {
          alreadySaved ? _saved.remove(pair) : _saved.add(pair);
        });
      },
    );
  }

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder:  (context, i) { // callback chamado 1 vez por sugestao dolocado na lista. Para cada par adiciona um divider
          if (i.isOdd) return Divider(); // adiciona divider

          final index = i ~/ 2; // pega a quantidade de elementos que ja passou
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10)); // se ja passou os 10, adiciona +10
          }

          return _buildRow(_suggestions[index]);
        });
  }
}

class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => RandomWordsState();
}
