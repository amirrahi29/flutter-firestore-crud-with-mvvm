class StudentModel{

  int? id;
  String? name;
  String? email;
  String? password;
  String? image;

  StudentModel({this.id,this.name,this.email,this.password,this.image});

  factory StudentModel.fromJson(Map<String, dynamic> json)
  {
    return StudentModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toMap(){
    return{
      'id':id,
      'name':name,
      'email':email,
      'password':password,
      'image':image,
    };
  }

}