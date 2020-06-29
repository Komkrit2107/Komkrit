class Resultt {
  String dataDate;
  String fUNDTYPE;
  double aVGCOST;
  double tOTALCOST;
  double uNGL;
  double uNGLP;

  Resultt(
      {this.dataDate,
      this.fUNDTYPE,
      this.aVGCOST,
      this.tOTALCOST,
      this.uNGL,
      this.uNGLP});

  Resultt.fromJson(Map<String, dynamic> json) {
    dataDate = json['DataDate'];
    fUNDTYPE = json['FUND_TYPE'];
    aVGCOST = chekDouble(json['AVG_COST']);
    tOTALCOST = chekDouble(json['TOTAL_COST']);
    uNGL = chekDouble(json['UN_GL']);
    uNGLP = chekDouble(json['UN_GL_P']);
  }


double  chekDouble(var value) {
    return value is int ? value.toDouble() : value;
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DataDate'] = this.dataDate;
    data['FUND_TYPE'] = this.fUNDTYPE;
    data['AVG_COST'] = this.aVGCOST;
    data['TOTAL_COST'] = this.tOTALCOST;
    data['UN_GL'] = this.uNGL;
    data['UN_GL_P'] = this.uNGLP;
    return data;
  }
}