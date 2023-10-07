import 'package:flutter/material.dart';
import 'package:secondflutter/const_cmp.dart';

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

  String getCost(){return cost.round().toString().padRight(3," ").padLeft(1," ");}
  String getGHG(){return ghg.round().toString().padRight(3," ").padLeft(1," ");}
  String getH2O(){return H2O.round().toString().padRight(3," ").padLeft(1," ");}
  String getLand(){return land.round().toString().padRight(3," ").padLeft(1," ");}
  String getProtest(){return protest.round().toString().padRight(3," ").padLeft(1," ");}

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
    if (ghg>4.5) return "None";
    if ((H2O<13.5)&(land<13.5)&(protest<49.5)) {
      if ((chainId.contains("50"))|(chainId.contains("51"))|(chainId.contains("52"))){
        return CHALLENGE2;}
      if ((chainId.contains("44"))|(chainId.contains("45"))|(chainId.contains("46"))|(chainId.contains("13"))|(chainId.contains("14"))){
        return CHALLENGE3;
      } else {
        if (ghg<=0) {return CHALLENGE5;}
        else {return CHALLENGE4;}
      }
    } else {return CHALLENGE2;}
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