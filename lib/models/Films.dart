import 'dart:convert';

class FilmsList{
  List<Films> filmsList;

  FilmsList({this.filmsList});

  factory FilmsList.fromJson(List<dynamic> parsedJson){
    List<Films> _filmsList=new List<Films>();
    _filmsList=parsedJson.map((i)=>Films.fromJson(i)).toList();

    return new FilmsList(
      filmsList:_filmsList,
    );
  }
 
}

class Films{
  //[{"_id":"5f383c0f3fc9b4001a525ecf","name":"Wolf Of Wall Street","rating":"4","__v":0}]
  String id;
  String name;
  String rating;
  int v;

  Films({this.id,this.name,this.rating,this.v});

  factory Films.fromJson(Map<String,dynamic> jsonData){
    return Films(
      id:jsonData['_id'],
      name:jsonData['name'],
      rating:jsonData['rating'],
      v:jsonData['__v']
    );
  }

}