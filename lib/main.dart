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


  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Home(),
  ));
}


