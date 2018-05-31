import 'dart:async';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import 'package:flutter/material.dart';
import '../utils/auth.dart';

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
  String _userName;
  String _imageError = "";
  File _image;

  Future getImage(select) async {
    var image = select == SelectImage.camera
        ? await ImagePicker.pickImage(source: ImageSource.camera)
        : await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = image;
        _imageError = "";
      });
    }
    Navigator.pop(context);
  }

  saveInfo() {
    var form = formKey.currentState; 
    if (_image != null) {
      if (form.validate()) {
        form.save();
        print(_userName);
      }
    } else {
      setState(() {
        _imageError = "Insira uma foto";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(title),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text("Imagem de perfil"),
            new Center(
              child: InkWell(
                onTap: () => showDialog(
                      context: context,
                      builder: (context) => Container(
                            width: 400.0,
                            height: 500.0,
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
                                    onTap: () => getImage(SelectImage.gallery),
                                  ),
                                ],
                              ),
                            ),
                          ),
                    ),
                child: new Container(
                  width: 200.0,
                  height: 200.0,
                  child: _image == null
                      ? new Image.asset("assets/placeholder-image.png")
                      : new Image.file(
                          _image,
                          fit: BoxFit.fill,
                        ),
                ),
              ),
            ),
            new Text(
              _imageError,
              style: new TextStyle(color: Colors.redAccent),
            ),
            new Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Form(
                key: formKey,
                child: new TextFormField(
                  obscureText: true,
                  autofocus: false,
                  decoration: InputDecoration(
                      hintText: "Como gostaria de ser chamado?",
                      contentPadding:
                          const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32.0))),
                  validator: (value) =>
                      value.isEmpty ? "Este campo precisa ser preenchido" : null,
                  onSaved: (value) => this._userName = value,
                ),
              ),
            ),
            new Padding(
              padding: const EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 0.0),
              child: Material(
                borderRadius: BorderRadius.circular(30.0),
                shadowColor: Colors.red.shade100,
                elevation: 5.0,
                child: MaterialButton(
                  height: 42.0,
                  onPressed: () {
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
          ],
        ),
      ),
    );
  }
}
