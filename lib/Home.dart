import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'helper/AnotacaoHelper.dart';
import 'model/Anotacao.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  TextEditingController _tituloController = TextEditingController();
  TextEditingController _descricaoController = TextEditingController();
  var _db = AnotacaoHelper();
  List<Anotacao> _anotacoes = List<Anotacao>();

  //TESTE DE UPLOAD DE DADOS PARA O FIREBASE
  //String _statusUpload = "Upload não iniciado";

//******************************************************************************
  _exibirTelaCadastro( { Anotacao anotacao }){
    String textoSalvarAtualizar = "";

    if( anotacao == null ) {
      _tituloController.text = "";
      _descricaoController.text = "";
      textoSalvarAtualizar = "Salvar";
    }else {
      _tituloController.text = anotacao.titulo;
      _descricaoController.text = anotacao.descricao;
      textoSalvarAtualizar = "Atualizar";
    }

    showDialog(
        context:context,
        builder: ( context ){
          return AlertDialog(
            title: Text("$textoSalvarAtualizar anotação"),
            content: Column(
              mainAxisSize: MainAxisSize.min, //por padrão vem máximo, ajustado para dialog menor
              children: <Widget>[
                TextField(
                  controller:_tituloController,
                  autofocus: true,
                  decoration: InputDecoration(
                      labelText: "Título",
                      hintText:"Digite o título..."
                  ),
                ),
                TextField(
                  controller:_descricaoController,
                  autofocus: true,
                  decoration: InputDecoration(
                      labelText: "Descrição",
                      hintText:"Digite a Descrição..."
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                //cancelar
                onPressed:()=>Navigator.pop(context) , //fecha tela, com navigator.pop
                child: Text("Cancelar"),
              ),
              TextButton(
                onPressed:() {
                  //salvar
                  _salvarAtualizarAnotacao( anotacaoSelecionada: anotacao );
                  Navigator.pop(context);
                },
                child: Text(textoSalvarAtualizar),
              )
            ],
          );
        }
    );
  }
//******************************************************************************
  _recuperarAnotacoes() async {
    List anotacoesRecuperadas = await _db.recuperarAnotacoes();
    List<Anotacao> listaTemporaria = List<Anotacao>();

    for ( var item in anotacoesRecuperadas ){
      Anotacao anotacao = Anotacao.fromMap( item );
      listaTemporaria.add( anotacao );
    }
    setState(() {
      _anotacoes = listaTemporaria;
    });
    listaTemporaria = null;
    //print("Lista anotacoes: " + anotacoesRecuperadas.toString() );
  }

//******************************************************************************
  _salvarAtualizarAnotacao( { Anotacao anotacaoSelecionada }) async {
    String titulo = _tituloController.text;
    String descricao = _descricaoController.text;

    if ( anotacaoSelecionada == null ){//salvar
      Anotacao anotacao = Anotacao( titulo, descricao, DateTime.now().toString() );
      int resultado = await _db.salvarAnotacao( anotacao );
    }else{ //atualizar
      anotacaoSelecionada.titulo = titulo;
      anotacaoSelecionada.descricao = descricao;
      anotacaoSelecionada.data = DateTime.now().toString();
      int resultado = await _db.atualizarAnotacao(anotacaoSelecionada);
    }


    // Anotacao anotacao = Anotacao( titulo, descricao, DateTime.now().toString() );
    //  int resultado = await _db.salvarAnotacao( anotacao );
    _tituloController.clear();
    _descricaoController.clear();
    _recuperarAnotacoes();
    enviarNuvem( );




  }
  //******************************************************************************
  _formatarData(String data){
    //Year - y   month -M     Day -> d
    //Hour->H    minute->m    second ->s
    initializeDateFormatting("pt_BR");
    //var formatador = DateFormat("d/MMMM/y H:m:s");
    var formatador = DateFormat.yMd("pt_BR");
    DateTime dataConvertida = DateTime.parse( data );
    String dataFormatada= formatador.format( dataConvertida);

    return dataFormatada;
  }
//******************************************************************************
  _removerAnotacao( int id ) async {
    await _db.removerAnotacao( id );
    _recuperarAnotacoes();

  }

//**************** TESTE DE ENVIO PARA FIREBASE SALVAR E ATUALIZAR***********************************
  enviarNuvem( ) async {
  List anotacoesRecuperadas = await _db.recuperarAnotacoes();
  FirebaseFirestore db = FirebaseFirestore.instance;

     for (var item in anotacoesRecuperadas) {
      db.collection("anotacao")
      .doc(item.id )
      .set({
            "titulo": item.titulo,
            "descricao": item.descricao,
           });
    }
  }




//******************************************************************************
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _recuperarAnotacoes();

  }
//******************************************************************************
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("DEMONSTRAÇÃO UFPI TCC2"),
        backgroundColor: Colors.lightGreen,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
              child: ListView.builder(
                  itemCount: _anotacoes.length,
                  itemBuilder:(context, index){
                    final anotacao = _anotacoes[index];
                    return Card(
                      child: ListTile(
                        title:Text( anotacao.titulo ),
                        subtitle: Text("${_formatarData(anotacao.data)} - ${anotacao.descricao}"),
                        trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children:<Widget>[
                              GestureDetector(
                                onTap:(){
                                  _exibirTelaCadastro(anotacao: anotacao);

                                },
                                child: Padding(
                                  padding: EdgeInsets.only(right:16),
                                  child: Icon(
                                    Icons.edit,
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap:(){
                                  _removerAnotacao( anotacao.id);
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(right:0),
                                  child: Icon(
                                    Icons.remove_circle,
                                    color: Colors.red,
                                  ),
                                ),
                              )
                            ]
                        ),
                      ),
                    );
                  }
              )
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          child: Icon(Icons.add),
          onPressed: (){
            _exibirTelaCadastro();
          }
      ),
    );
  }
}
