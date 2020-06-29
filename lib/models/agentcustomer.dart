class ResultCus {
  int mktId;
  String userName;
  String custCode;
  String fullName;
  String birthDay;
  String mobile;
  String email;
  String loginName;
  String pASSWD;
  int userLevel;
  String titleName;
  String fullNamess;

  ResultCus(
      {this.mktId,
      this.userName,
      this.custCode,
      this.fullName,
      this.birthDay,
      this.mobile,
      this.email,
      this.loginName,
      this.pASSWD,
      this.userLevel,
      this.titleName,
      this.fullNamess,
      });

  ResultCus.fromJson(Map<String, dynamic> json) {
    mktId = json['MktId'];
    userName = json['User_Name'];
    custCode = json['Cust_Code'];
    fullName = json['Full_Name'];
    birthDay = json['Birth_Day'];
    mobile = json['Mobile'];
    email = json['Email'];
    loginName = json['LoginName'];
    pASSWD = json['PASS_WD'];
    userLevel = json['User_Level'];
    titleName = json['Title_Name'];
    fullNamess = json['FullNamess'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['MktId'] = this.mktId;
    data['User_Name'] = this.userName;
    data['Cust_Code'] = this.custCode;
    data['Full_Name'] = this.fullName;
    data['Birth_Day'] = this.birthDay;
    data['Mobile'] = this.mobile;
    data['Email'] = this.email;
    data['LoginName'] = this.loginName;
    data['PASS_WD'] = this.pASSWD;
    data['User_Level'] = this.userLevel;
    data['Title_Name'] = this.titleName;
    data['FullNamess'] = this.fullNamess;
    return data;
  }
}