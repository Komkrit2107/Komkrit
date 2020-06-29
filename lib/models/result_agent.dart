class Resultgent {
  int userId;
  String fullName;
  String levelUser;

  Resultgent({this.userId, this.fullName, this.levelUser});

  Resultgent.fromJson(Map<String, dynamic> json) {
    userId = json['User_Id'];
    fullName = json['Full_Name'];
    levelUser = json['LevelUser'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['User_Id'] = this.userId;
    data['Full_Name'] = this.fullName;
    data['LevelUser'] = this.levelUser;
    return data;
  }
}
