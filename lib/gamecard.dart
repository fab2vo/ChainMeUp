import 'package:flutter/material.dart';

class GameCard{
  final int num;
  final Color color;
  GameCard( this.num,  this.color);
}

class ChainResult {
  String chainId;
  double cost;
  double ghg;
  double H2O;
  double land;
  double protest;

  ChainResult(this.chainId, this.cost, this.ghg, this.H2O, this.land,
      this.protest);

  ChainResult.short (List<dynamic> lin)
      : this(lin[0], lin[1], lin[2], lin[3], lin[4], lin[5]);

  Map<String, dynamic> toMap() {
    return {
      "Chain Id": chainId,
      "Cost": cost,
      "GHG": ghg,
      "H2O": H2O,
      "Land": land,
      "Protest": protest
    };
  }

  String getChallengeresult() {
    if (ghg>4.5) return "No challenge";
    if ((H2O<13.5)&(land<13.5)&(protest<49.5)) {
      if ((chainId.contains("50"))|(chainId.contains("51"))|(chainId.contains("52"))){
        return "Low carbon";}
      if ((chainId.contains("44"))|(chainId.contains("45"))|(chainId.contains("46"))|(chainId.contains("13"))|(chainId.contains("14"))){
        return "Sust.";
      } else {
        if (ghg<=0) {return "Net Zero";}
        else {return "Sust. Large";}
      }
    } else {return "Low carbon";}
    return "No challenge";
  }
  String affi() {
    String _res="";
    _res +=cost.toString().padRight(8," ");
    _res +=ghg.toString().padRight(8," ");
    _res +=H2O.toString().padRight(8," ");
    _res +=land.toString().padRight(8," ");
    _res +=protest.toString().padRight(8," ");
    _res += getChallengeresult();
    _res +="\n";
    return _res;
  }
}