import 'package:flutter/material.dart';

class GameCard{
  final int num;
  final Color color;
  GameCard( this.num,  this.color);
}

class ChainResult{
  String chainId;
  double cost;
  double ghg;
  double H2O;
  double land;
  double protest;
  ChainResult(this.chainId,this.cost,this.ghg, this.H2O, this.land, this.protest);
  ChainResult.short (List<dynamic> lin) : this(lin[0],lin[1],lin[2],lin[3],lin[4],lin[5]);
  Map<String, dynamic> toMap(){
    return{"Chain Id":chainId, "Cost":cost, "GHG":ghg, "H2O":H2O, "Land":land,"Protest":protest};
  }
}