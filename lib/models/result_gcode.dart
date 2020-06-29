class Resultgroub {
  String custID;
  String amcCode;
  String amcName;
  String amcNameE;
  String fundCode;
  String fGroupCode;
  String fundNameT;
  String fundNameE;
  int riskLevel;
  double balanceUnit;
  double avgCostUnit;
  double avgCost;
  String dataDate;
  double marketPrice;
  double marketValue;
  double gainLoss;
  double returnPC;
  double proportion;
  double totalCost;

  Resultgroub(
      {this.custID,
      this.amcCode,
      this.amcName,
      this.amcNameE,
      this.fundCode,
      this.fGroupCode,
      this.fundNameT,
      this.fundNameE,
      this.riskLevel,
      this.balanceUnit,
      this.avgCostUnit,
      this.avgCost,
      this.dataDate,
      this.marketPrice,
      this.marketValue,
      this.gainLoss,
      this.returnPC,
      this.proportion,
      this.totalCost});

  Resultgroub.fromJson(Map<String, dynamic> json) {
    custID = json['CustID'];
    amcCode = json['Amc_Code'];
    amcName = json['Amc_Name'];
    amcNameE = json['amcNameE'];
    fundCode = json['Fund_Code'];
    fGroupCode = json['FGroup_Code'];
    fundNameT = json['fundNameT'];
    fundNameE = json['fundNameE'];
    riskLevel = json['RiskLevel'];
    balanceUnit = chekDouble(json['BalanceUnit']);
    avgCostUnit = chekDouble(json['AvgCostUnit']);
    avgCost = chekDouble(json['AvgCost']);
    dataDate = json['DataDate'];
    marketPrice = chekDouble(json['MarketPrice']);
    marketValue = chekDouble(json['MarketValue']);
    gainLoss = chekDouble(json['GainLoss']);
    returnPC = chekDouble(json['ReturnPC']);
    proportion = chekDouble(json['Proportion']);
    totalCost = chekDouble(json['TotalCost']);
  }


  double  chekDouble(var value) {
    return value is int ? value.toDouble() : value;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CustID'] = this.custID;
    data['Amc_Code'] = this.amcCode;
    data['Amc_Name'] = this.amcName;
    data['amcNameE'] = this.amcNameE;
    data['Fund_Code'] = this.fundCode;
    data['FGroup_Code'] = this.fGroupCode;
    data['fundNameT'] = this.fundNameT;
    data['fundNameE'] = this.fundNameE;
    data['RiskLevel'] = this.riskLevel;
    data['BalanceUnit'] = this.balanceUnit;
    data['AvgCostUnit'] = this.avgCostUnit;
    data['AvgCost'] = this.avgCost;
    data['DataDate'] = this.dataDate;
    data['MarketPrice'] = this.marketPrice;
    data['MarketValue'] = this.marketValue;
    data['GainLoss'] = this.gainLoss;
    data['ReturnPC'] = this.returnPC;
    data['Proportion'] = this.proportion;
    data['TotalCost'] = this.totalCost;
    return data;
  }
}