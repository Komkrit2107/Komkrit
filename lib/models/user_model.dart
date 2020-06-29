class UserModel {
  String token;
  int expiresIn;
  String userData;
  String loginName;
  String uSERID;
  String fULLNAME;
  String mSGCODE;
  String mSGDESC;
  int mktId;
  int userLevel;
  String titleName;
  String fullNamess;

  UserModel(
      {this.token,
      this.expiresIn,
      this.userData,
      this.loginName,
      this.uSERID,
      this.fULLNAME,
      this.mSGCODE,
      this.mSGDESC,
      this.mktId,
      this.userLevel,
      this.titleName,
      this.fullNamess});

  UserModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    expiresIn = json['expiresIn'];
    userData = json['userData'];
    loginName = json['LoginName'];
    uSERID = json['USERID'];
    fULLNAME = json['FULLNAME'];
    mSGCODE = json['MSG_CODE'];
    mSGDESC = json['MSG_DESC'];
    mktId = json['MktId'];
    userLevel = json['User_Level'];
    titleName = json['Title_Name'];
    fullNamess = json['FullNamess'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['expiresIn'] = this.expiresIn;
    data['userData'] = this.userData;
    data['LoginName'] = this.loginName;
    data['USERID'] = this.uSERID;
    data['FULLNAME'] = this.fULLNAME;
    data['MSG_CODE'] = this.mSGCODE;
    data['MSG_DESC'] = this.mSGDESC;
    data['MktId'] = this.mktId;
    data['User_Level'] = this.userLevel;
    data['Title_Name'] = this.titleName;
    data['FullNamess'] = this.fullNamess;
    return data;
  }
}

