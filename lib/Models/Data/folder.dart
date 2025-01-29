class folder{
  int? id;
  String name;
  String color;

  folder({required this.id, required this.name, required this.color});

  //from Json
  factory folder.fromJson(Map<String, dynamic> json){
    return folder(id: json['id'] as int, name: json['name'], color: json['color']);
  }

  //toJson
  Map<String, dynamic> toJson() =>{
    'id': id,
    'name': name,
    'color': color
  };
}