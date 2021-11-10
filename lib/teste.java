import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

        void main() async {

        Firestore db = Firestore.instance;


        db.collection("usuarios").snapshots().listen(
        ( snapshot ){

        for( DocumentSnapshot item in snapshot.documents ){
        var dados = item.data;
        print("dados usuarios: " + dados["nome"] + " - " + dados["idade"] );
        }

        }
        );

        runApp(App());

        }

class App extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return Container();
    }
}
