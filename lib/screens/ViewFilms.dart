import 'dart:convert';
import 'package:FilmsApp/models/Films.dart';
import 'package:FilmsApp/models/PostsModel.dart';
import 'package:FilmsApp/screens/AddMovie.dart';
import 'package:FilmsApp/states/LoginState.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ViewFilms extends StatefulWidget {
  @override
  _ViewFilms createState() => _ViewFilms();
}

class _ViewFilms extends State<ViewFilms>
    with AutomaticKeepAliveClientMixin<ViewFilms> {
  String moviesEndpoint = "https://moviestore-se572.herokuapp.com/api/v1/films";
  List<Films> apiData = new List<Films>();
  String rating = "One";
  String testData = "";
  bool isLoggedIn = false;
  @override
  Widget build(BuildContext context) {
    http.Response _response;
    LoginState _loginState = Provider.of<LoginState>(context);
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            apiData.length == 0
                ? noFilms()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: filmWidgetList(apiData, context, _loginState)),
            FlatButton(
              child: Text('Get Movies'),
              onPressed: () async => {fetchMovies()},
              color: Colors.blue,
              splashColor: Colors.amberAccent,
            )
          ],
        ),
      ),
    ));
  }

  fetchMovies() async {
    var _response = await http.get(moviesEndpoint);
    this.setState(() {
      apiData = new List<Films>();
      //http.Response response = await http.get(getMoviesEndpoint);
      if (_response.statusCode == 200) {
        var pl = PostsListModel.fromJson(json.decode(_response.body));

        pl.postsListsModel.forEach((element) {
          apiData.add(new Films(
              id: element.id,
              name: element.name,
              v: element.v,
              rating: element.rating));
        });
      } else {
        alertMessage(context, "Please try again!!!");
      }
    });
  }

  Widget noFilms() {
    return Container(
      child: Text('Add Some Films!'),
    );
  }

  createRatingBar(String rating) {
    return RatingBar(
      initialRating: double.parse(rating),
      direction: Axis.horizontal,
      itemSize: 15,
      itemCount: 5,
      itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
      itemBuilder: (context, _) => Icon(
        Icons.star,
        color: Colors.amber,
      ),
      //onRatingUpdate: () => {},
    );
  }

  filmWidgetList(List<Films> _apiData, context, LoginState _loginState) {
    List<Widget> _widget = new List<Widget>();
    _widget.add(SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
          columns: [
            DataColumn(label: Text("Movie Name")),
            DataColumn(label: Text("Rating")),
            DataColumn(label: Text(""))
          ],
          rows: _apiData
              .map((e) => DataRow(
                    cells: [
                      DataCell(Text(e.name,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16.5))),
                      DataCell(createRatingBar(e.rating)),
                      _loginState.getLoggedInStatus()
                          ? DataCell(IconButton(
                              icon: Icon(Icons.update),
                              onPressed: () => {
                                    this.setState(() {
                                      rating = "One";
                                    }),
                                    updateRating(
                                        e.name, e.rating, context, _loginState)
                                  }))
                          : DataCell(Text('Login to Update!'))
                    ],
                  ))
              .toList()),
    ));
    return _widget;
  }

  @override
  bool get wantKeepAlive => true;

  //createDropDown(setDropDownValue, dropDownValue) {}
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

  updateRating(String name, String rating, context, LoginState _loginState) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        String dropDownValue = "One";

        return AlertDialog(
          title: Text(
            "Update Rating for Movie $name",
            style: TextStyle(fontSize: 18),
          ),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              http.Response _response;
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  //createDropDown(setDropDownValue, getDropDownValue)
                  DropdownButton<String>(
                    value: dropDownValue,
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
                        dropDownValue = newValue;
                      });
                    },
                    items: <String>['One', 'Two', 'Three', 'Four', 'Five']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  FlatButton(
                    onPressed: () async => {
                      //Navigator.pop(context),
                      // print(
                      //     "Rating is $rating and DropdownValue is $dropDownValue"),
                      if (rating == starMapper(dropDownValue))
                        {
                          Navigator.pop(context),
                          alertMessage(context, "Rating is same as before!"),
                          //Scaffold.of(context).showSnackBar(SnackBar(
                          //  content: Text("Rating is same as before!")))
                          //Navigator.pop(context)
                        }
                      else
                        {
                          _response = await http.put(moviesEndpoint,
                              headers: <String, String>{
                                "Content-Type": "application/json",
                                "Authorization":
                                    "Bearer ${_loginState.getToken()}"
                              },
                              body: json.encode({
                                'name': name,
                                "rating": starMapper(dropDownValue)
                              })),
                          if (json.decode(_response.body)["ok"] == 1)
                            {
                              if (json.decode(_response.body)["nModified"] == 1)
                                {
                                  Navigator.pop(context),
                                  alertMessage(context, "Rating Updated!!!"),
                                  //Navigator.pop(context),
                                  //SnackBar(content: Text("Rating updated!!!")),
                                  fetchMovies()
                                }
                            }
                          //print("New Rating is ${dropDownValue}")
                        }
                    },
                    child: Text('UPDATE'),
                    color: Colors.blue,
                    splashColor: Colors.amber,
                  )
                ],
              );
            },
          ),
        );
      },
    );
    // http.put(moviesEndpoint,
    //     headers: <String, String>{"Content-Type": "application/json"},
    //     body: json.encode({"name":name,"rating":rating}));
  }
}
