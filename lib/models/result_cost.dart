class Resultcost {
  String custID;
  double totalcost;
  double totalsum;
  double marketValue;
  double gainLoss;
  double returnPC;
  String dataDate;

  Resultcost(
      {this.custID,
      this.totalcost,
      this.totalsum,
      this.marketValue,
      this.gainLoss,
      this.returnPC,
      this.dataDate});

  Resultcost.fromJson(Map<String, dynamic> json) {
    custID = json['CustID'];
    totalcost = chekDouble(json['Totalcost']);
    totalsum = chekDouble(json['Totalsum']);
    marketValue = chekDouble(json['MarketValue']);
    gainLoss = chekDouble(json['GainLoss']);
    returnPC = chekDouble(json['ReturnPC']);
    dataDate = json['DataDate'];
  }

  double  chekDouble(var value) {
    return value is int ? value.toDouble() : value;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CustID'] = this.custID;
    data['Totalcost'] = this.totalcost;
    data['Totalsum'] = this.totalsum;
    data['MarketValue'] = this.marketValue;
    data['GainLoss'] = this.gainLoss;
    data['ReturnPC'] = this.returnPC;
    data['DataDate'] = this.dataDate;
    return data;
  }
}