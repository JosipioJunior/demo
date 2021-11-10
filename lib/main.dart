import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_tcc/model/Anotacao.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'Home.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'helper/AnotacaoHelper.dart';
/*
void main() =>  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home:Home(),
    ));
*/

void main() async {

//Configuração Firebase
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();

    FirebaseFirestore db = FirebaseFirestore.instance;

//****************SALVAR E ATUALIZAR***********************************
  var _db = AnotacaoHelper();
  List<Anotacao> _anotacoes = List<Anotacao>();

  enviarCloud() async {
//    List anotacoesRecuperadas = await _db.recuperarAnotacoes();
//    List<Anotacao> listaTemporaria = List<Anotacao>();
    Anotacao anotacao;
//    for (var item in anotacoesRecuperadas) {

      db.collection("anotacao")
          .add({
        "titulo": anotacao.titulo,
        "descricao": anotacao.descricao
      });
//    }
  }

//
//  DocumentReference ref = await db.collection("teste")
//  .add({
//    "nome":"Junior",
//    "idade": "31"
//  });

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Home(),
  ));
}


