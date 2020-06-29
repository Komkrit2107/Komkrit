class Resultsale {
  String tranTypeCode;
  String tranDate;
  String refNo;
  String executeDate;
  double amountBaht;
  double amountUnit;
  double navPrice;
  double avgCost;
  double costAmountBaht;
  double rGL;
  double rGLP;
  String actExecDate;
  Null sUMRGL;

  Resultsale(
      {this.tranTypeCode,
      this.tranDate,
      this.refNo,
      this.executeDate,
      this.amountBaht,
      this.amountUnit,
      this.navPrice,
      this.avgCost,
      this.costAmountBaht,
      this.rGL,
      this.rGLP,
      this.actExecDate,
      this.sUMRGL});

  Resultsale.fromJson(Map<String, dynamic> json) {
    tranTypeCode = json['TranType_Code'];
    tranDate = json['Tran_Date'];
    refNo = json['Ref_No'];
    executeDate = json['ExecuteDate'];
    amountBaht = json['Amount_Baht'];
    amountUnit = json['Amount_Unit'];
    navPrice = json['Nav_Price'];
    avgCost = json['Avg_Cost'];
    costAmountBaht = json['Cost_Amount_Baht'];
    rGL = json['RGL'];
    rGLP = json['RGL_P'];
    actExecDate = json['Act_ExecDate'];
    sUMRGL = json['SUMRGL'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['TranType_Code'] = this.tranTypeCode;
    data['Tran_Date'] = this.tranDate;
    data['Ref_No'] = this.refNo;
    data['ExecuteDate'] = this.executeDate;
    data['Amount_Baht'] = this.amountBaht;
    data['Amount_Unit'] = this.amountUnit;
    data['Nav_Price'] = this.navPrice;
    data['Avg_Cost'] = this.avgCost;
    data['Cost_Amount_Baht'] = this.costAmountBaht;
    data['RGL'] = this.rGL;
    data['RGL_P'] = this.rGLP;
    data['Act_ExecDate'] = this.actExecDate;
    data['SUMRGL'] = this.sUMRGL;
    return data;
  }
}