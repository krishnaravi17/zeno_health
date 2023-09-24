class User {
  late final int id;
  late final String user_name;
  late final int age;
  late final String password;

  User(
      {required this.id,
      required this.user_name,
      required this.age,
      required this.password});

  User.fromMap(Map<String, dynamic> result)
      : id = result["id"],
        user_name = result["user_name"],
        age = result["age"],
        password = result["password"];
  Map<String, Object> toMap() {
    return {'id': id, 'user_name': user_name, 'age': age, 'password': password};
  }
}
