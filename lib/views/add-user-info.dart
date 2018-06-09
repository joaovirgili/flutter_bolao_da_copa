import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

import '../utils/auth.dart';
import '../utils/storage.dart';
import '../utils/singleton.dart';

class AddUserInfo extends StatefulWidget {
  AddUserInfo({this.title, this.auth});
  final BaseAuth auth;
  final String title;
  static const String routeName = "/AddInfo";

  @override
  _AddUserInfoState createState() =>
      new _AddUserInfoState(title: title, auth: auth);
}

enum SelectImage { camera, gallery }

class _AddUserInfoState extends State<AddUserInfo> {
  _AddUserInfoState({this.auth, this.title});
  final BaseAuth auth;
  final String title;

  final formKey = new GlobalKey<FormState>();
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  String _userName;
  File _image;
  ScrollController _scrollController = new ScrollController();
  FocusNode _focus = new FocusNode();

  @override
  initState() {
    super.initState();
    _focus.addListener(_onFocusChange);
  }

  _onFocusChange() {
    _scrollController.position.maxScrollExtent;
  }

  Future getImage(select) async {
    var image = select == SelectImage.camera
        ? await ImagePicker.pickImage(source: ImageSource.camera)
        : await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = image;
      });
    }
    Navigator.pop(context);
  }

  saveInfo() async {
    var form = formKey.currentState;
    if (_image != null) {
      if (form.validate()) {
        form.save();
        print("Fazendo upload da imagem..");
        Storage().uploadImage(_userName, _image).then((photoUri) async {
          print("Upload completo");
          await auth.updateProfile(_userName, photoUri.toString());
          await auth.currentUser().then((user) {
            _insertIntoDatabase(user.uid, photoUri);
          });
          Navigator.pop(context);
          Navigator.pushNamedAndRemoveUntil(context, "/Main", (v) => false);
        });
      }
    } else {
      Navigator.pop(context);
      scaffoldKey.currentState.showSnackBar(new SnackBar(
        content: new Text("Selecione uma foto de perfil."),
        duration: new Duration(seconds: 3),
      ));
    }
  }

    _insertIntoDatabase(id, photoUri) {
    Map<String, String> data = <String, String>{
      "photo": photoUri.toString(),
      "username": _userName,
    };
    print("Inserindo dados adicionais de $id");
    Firestore.instance
        .collection("users")
        .document(id)
        .updateData(data)
        .then((a) {
      print("Dados inseridos no banco.");
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: scaffoldKey,
      appBar: new AppBar(
        title: new Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Center(
          child: new ListView(
            shrinkWrap: true,
            reverse: true,
            controller: _scrollController,
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.fromLTRB(86.0, 12.0, 86.0, 0.0),
                child: Material(
                  borderRadius: BorderRadius.circular(30.0),
                  shadowColor: Colors.red.shade100,
                  elevation: 5.0,
                  child: MaterialButton(
                    height: 42.0,
                    onPressed: () {
                      new Singleton().showLoadingDialog(context);
                      saveInfo();
                    },
                    color: Theme.of(context).primaryColor,
                    child: new Text(
                      "Salvar",
                      style: new TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              new Padding(
                padding: const EdgeInsets.fromLTRB(32.0, 12.0, 32.0, 0.0),
                child: Form(
                  key: formKey,
                  child: new TextFormField(
                    focusNode: _focus,
                    autofocus: false,
                    decoration: InputDecoration(
                        hintText: "Como gostaria de ser chamado?",
                        contentPadding:
                            const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32.0))),
                    validator: (value) => value.isEmpty
                        ? "Este campo precisa ser preenchido"
                        : null,
                    onSaved: (value) => this._userName = value,
                  ),
                ),
              ),
              new Center(
                child: InkWell(
                  onTap: () => showDialog(
                        context: context,
                        builder: (context) => Container(
                              child: AlertDialog(
                                title: new Text("Imagem"),
                                content: new Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    new ListTile(
                                      title: new Text("Camera"),
                                      leading: new Icon(Icons.photo_camera),
                                      onTap: () => getImage(SelectImage.camera),
                                    ),
                                    new ListTile(
                                      title: new Text("Galeria"),
                                      leading: new Icon(Icons.photo),
                                      onTap: () =>
                                          getImage(SelectImage.gallery),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                      ),
                  child: new Container(
                    height: 350.0,
                    child: _image == null
                        ? new Image.asset("assets/placeholder-image.png")
                        : new Image.file(
                            _image,
                          ),
                  ),
                ),
              ),
              new Center(
                  child: new Text(
                      "Clique na imagem para inserir sua foto de perfil")),
              // new Text("Bem-vindo ao Bolão do Eh Nóis!"),
            ],
          ),
        ),
      ),
    );
  }
}
