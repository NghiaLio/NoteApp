class note {
  int? id;
  String content;
  String title;
  String date;
  String date_change;
  bool isLock;
  bool isDelete;
  String password;
  int? localFolder;
  bool isFavorite;

  note(
      {required this.id,
        required this.content,
      required this.date,
        required this.date_change,
      required this.isFavorite,
      required this.isLock,
      required this.isDelete,
      required this.localFolder,
      required this.password,
      required this.title});

  // toJson
  Map<String, dynamic> toJson()=>
      {
        'content': content,
        'date': date,
        'dateChange': date_change,
        'isFavorite': isFavorite ? 1: 0,
        'isLock': isLock ? 1: 0,
        'isDelete': isDelete ? 1 : 0,
        'localFolder': localFolder,
        'password': password,
        'title': title
      };

  //fromJson
  factory note.fromJson(Map<String, dynamic> json){
    return note(
      id: json['id'] as int,
        content: json['content'],
        date: json['date'],
        date_change: json['dateChange'],
        isFavorite: json['isFavorite'] == 1,
        isLock: json['isLock'] == 1,
        isDelete: json['isDelete'] == 1,
        localFolder: json['localFolder'],
        password: json['password'],
        title: json['title']
    );
  }
}



