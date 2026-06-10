
class UserModel {
  final String userId;
  final String name;
  final String email;
  final String? imageUrl;
  final String password;
 

  UserModel({
    required this.userId,
    required this.name,
    required this.email,
    this.imageUrl,
    required this.password,
   
  });

  // convert to dart
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json["userId"] ?? "",
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      imageUrl: json["imageUrl"] ?? "",
      password: json["password"] ?? "",
      
    );
  }

  get base64Image => null;

  // todo: convert to json
  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "name": name,
      "email": email,
      "imageUrl": imageUrl,
      "password": password,
  
    };
  }
}