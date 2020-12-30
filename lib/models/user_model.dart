class UserModel {
  String uid;
  String email;
  String displayName;
  String phoneNumber;
  String photoUrl;

  UserModel(
      {this.uid,
      this.email,
      this.displayName,
      this.phoneNumber,
      this.photoUrl});

  Map<String, dynamic> toMap() {
    return {'uid': uid, 'email': email};
  }

}
