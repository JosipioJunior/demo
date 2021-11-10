import 'package:cloud_firestore/cloud_firestore.dart';

class Anotacao{
//  int id ;
//  String titulo;
//  String descricao;
//  String data;
  int _id ;
  String _titulo;
  String _descricao;
  String _data;

//******************************************************************************
 //REMOVIDO DEPOIS GETTERSETTER Anotacao( this.titulo, this.descricao, this.data );
//******************************************************************************
  Anotacao.fromMap( Map map){

    this.id = map ["id"];      //this.id = map [AnotacaoHelper.colunaId];
    this.titulo = map ["titulo"];
    this.descricao = map ["descricao"];
    this.data = map ["data"];
  }
//******************************************************************************
  Map toMap(){

    Map<String, dynamic> map = {
      "titulo": this.titulo,
      "descricao": this.descricao,
      "data": this.data,
    };
    if( this.id != null ){
      map["id"] = this.id;
    }
    return map;
  }
//******************************************************************************

  Anotacao.fromDocumentSnapshot(DocumentSnapshot documentSnapshot){

    this.id = documentSnapshot.documentID;
    this.titulo     = documentSnapshot["titulo"];
    this.descricao  = documentSnapshot["descricao"];


  }

  Anotacao.gerarId(){

    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference anotacao = db.collection("anotacoes");
    this.id = anotacao.document().documentID;
  }

  //GETTER E SETTERS
  int get id => _id;
  set id(int value) {
    _id = value;
  }

  String get titulo => _titulo;
  set titulo(String value) {
    _titulo = value;
  }

  String get descricao => _descricao;
  set descricao(String value) {
    _descricao = value;
  }

  String get data => _data;
  set data(String value) {
    _data = value;
  }

}