import 'dart:convert';
import 'dart:io';

import 'package:FilmsApp/states/LoginState.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class AddMovie extends StatefulWidget {
  @override
  _AddMovieState createState() => _AddMovieState();
}

class _AddMovieState extends State<AddMovie>
    with AutomaticKeepAliveClientMixin<AddMovie> {
  String dropdownValue = "One";
  String _movieName = "";
  String loginName = "";
  String postMoviesEndpoint =
      "https://moviestore-se572.herokuapp.com/api/v1/films";
  String token;

  setTokenState(_token) {
    this.setState(() {
      token = _token;
      print(token);
    });
  }

  setLoginNameState(_loginName) {
    this.setState(() {
      loginName = _loginName;
      print(loginName);
    });
  }

  @override
  Widget build(BuildContext context) {
    //print(this.token);
    http.Response response;
    LoginState _LoginState = Provider.of<LoginState>(context);
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json", // or whatever
      HttpHeaders.authorizationHeader: "Bearer $token",
    };
    return Scaffold(
        body: Container(
      child: Column(
        children: [
          SizedBox(height: 20),
          this.token == null
              ? loginWidget(this.setTokenState, this.setLoginNameState, context,
                  this.loginName, _LoginState)
              : SizedBox(height: 2),
          this.token != null
              ? Column(
                  children: [
                    Text(
                      'Add Film',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    TextField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Enter Movie Name',
                          hintText: 'Movie Name'),
                      onChanged: (String newText) => {
                        setState(() {
                          _movieName = newText;
                          print(_movieName);
                        })
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Rating'),
                        SizedBox(width: 5),
                        new DropdownButton<String>(
                          value: dropdownValue,
                          icon: Icon(Icons.arrow_downward),
                          iconSize: 24,
                          elevation: 16,
                          style: TextStyle(color: Colors.deepPurple),
                          underline: Container(
                            height: 2,
                            color: Colors.deepPurpleAccent,
                          ),
                          onChanged: (String newValue) {
                            setState(() {
                              dropdownValue = newValue;
                            });
                          },
                          items: <String>['One', 'Two', 'Three', 'Four', 'Five']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        )
                      ],
                    ),
                    FlatButton(
                      onPressed: () async => {
                        if (this._movieName == "")
                          {alertMessage(context, "MovieName Can't be empty!")}
                        else
                          {
                            response = await http.post(postMoviesEndpoint,
                                headers: headers,
                                body: jsonEncode(<String, String>{
                                  'name': _movieName,
                                  "rating": starMapper(dropdownValue)
                                })),
                            print(
                                "Response Status Code is:${response.statusCode}"),
                            if (response.statusCode == 200)
                              {alertMessage(context, "Movie has been added")}
                            else if (response.statusCode == 418)
                              {alertMessage(context, "Movie Already Exists!")}
                            else if (response.statusCode == 403)
                              {
                                alertMessage(context,
                                    "Forbidden! Can't add movies, please signIn!")
                              }
                            else
                              {
                                alertMessage(context,
                                    "${response.statusCode} - ${response.reasonPhrase}")
                              }
                          }
                      },
                      child: Text('ADD FILM'),
                      color: Colors.blue,
                      splashColor: Colors.amber,
                    ),
                    FlatButton(
                      child: Text('LOGOUT'),
                      color: Colors.redAccent,
                      splashColor: Colors.blueAccent,
                      onPressed: () => {
                        alertMessage(context, "Logged Out Succesfully!"),
                        this.setState(() {
                          _movieName = "";
                        }),
                        setTokenState(null),
                        setLoginNameState(""),
                        _LoginState.flip(),
                        _LoginState.setJWT("")
                        //setLoginNameState("")
                      },
                    )
                  ],
                )
              : SizedBox(
                  height: 5,
                )
        ],
      ),
    ));
  }

  @override
  bool get wantKeepAlive => true;
}

String starMapper(String value) {
  if (value == "One")
    return "1";
  else if (value == "Two")
    return "2";
  else if (value == "Three")
    return "3";
  else if (value == "Four")
    return "4";
  else
    return "5";
}

alertMessage(context, messageContent) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Message"),
          content: Text(messageContent),
        );
      });
}

Widget loginWidget(setTokenState, setLoginNameState, context, loginName,
    LoginState _LoginState) {
  //print("Refreshed");
  //final textFieldController = TextEditingController();
  //String _userName = "";
  http.Response _loginResponse;
  return Container(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        TextField(
          //controller: textFieldController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Enter User Name',
          ),
          onChanged: (String newText) => {
            setLoginNameState(newText),
          },
        ),
        FlatButton(
          onPressed: () async => {
            if (loginName != "")
              {
                _loginResponse = await http.post(
                    "http://moviestore-se572.herokuapp.com/api/v1/login",
                    headers: <String, String>{
                      'Content-Type': 'application/json'
                    },
                    body: json.encode({'name': loginName})),
                print(json.decode(_loginResponse.body)['token']),
                alertMessage(context, "Succesfully Logged in!!!"),
                if (!_LoginState.getLoggedInStatus()) {_LoginState.flip()},
                //setLoggedIn(true),
                _LoginState.setJWT(json.decode(_loginResponse.body)['token']),
                setTokenState(json.decode(_loginResponse.body)['token']),
              }
            else
              {
                print("UserName:${loginName}"),
                //setLoggedIn(false),
                alertMessage(context, "Enter Login Name!")
              }
          },
          child: Text("LOGIN"),
          color: Colors.blue,
          splashColor: Colors.amber,
        )
      ],
    ),
  );
}
