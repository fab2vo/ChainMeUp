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

  String getCost(){return quickFormat(cost);}
  String getGHG(){return quickFormat(ghg);}
  String getH2O(){return quickFormat(H2O);}
  String getLand(){return quickFormat(land);}
  String getProtest(){return quickFormat(protest);}

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

  String quickFormat(double dd){
    String st=dd.round().toString().padRight(1);
    return st.padLeft(4-st.length," ");
  }

  bool isMassive(){
    if ((chainId.contains("45"))||(chainId.contains("46"))||(chainId.contains("44"))) return false;
    if ((chainId.contains("13"))||(chainId.contains("14"))){ //production H2 intermittent
        if ((chainId.contains("77"))||(chainId.contains("78"))) return true; //stockage H2
        return false;
    }
    return true;
  }
  String getChallengeresult() {
    if (ghg>4.5) return "None";
    if ((H2O<13.5)&&(land<13.5)&&(protest<49.5)) { //&& AND
      if ((chainId.contains("50"))||(chainId.contains("51"))||(chainId.contains("52"))){ // bois
        return lowEmission;}
      if (isMassive()) {
        if (ghg<=0) {return netZero;}
        return massiveSustainable;
      } else {
        return susTainable;}
    } else {return lowEmission;}
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
  bool testEqual(ChainResult x){
    return (x.chainId==chainId)&&(x.cost==cost)&&(x.ghg==ghg)&&(x.H2O==H2O)&&(x.land==land)&&(x.protest==protest);
  }
}