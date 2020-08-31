import 'package:FilmsApp/screens/AddMovie.dart';
import 'package:FilmsApp/screens/ViewFilms.dart';
import 'package:FilmsApp/states/LoginState.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Roboto'),
      home: ChangeNotifierProvider<LoginState>(
          create: (context) => LoginState(false), child: new HomePage())));
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // String getMoviesEndpoint = "http://localhost:8080/api/v1/films";
  // List<Films> apiData = new List<Films>();
  String tokenProvider;
  int tabControllerLength;
  bool isLoggedIn;

  get getLoggedDetails => isLoggedIn;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              title: Text("FilmsApp"),
              bottom: TabBar(tabs: [
                Tab(icon: Icon(Icons.view_agenda)),
                Tab(icon: Icon(Icons.add_circle))
              ]),
            ),
            body: TabBarView(children: [ViewFilms(), AddMovie()])));
  }

  var checkToken = () => {print("Testing")};

  getToken() {
    return this.tokenProvider;
  }

  setLoggedIn() {
    setState(() {
      isLoggedIn:
      true;
    });
    getLoggedDetails() {
      return isLoggedIn;
    }
  }
}
