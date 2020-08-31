import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Container(
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.,
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter UserName',
                      hintText: 'Enter UserName'),
                ),
              ),
              FlatButton(
                child: Text('LOGIN'),
                color: Colors.blue,
                splashColor: Colors.amberAccent,
                onPressed: () => {},
              )
            ],
          ),
        ));
  }
}
