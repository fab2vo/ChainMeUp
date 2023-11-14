import 'package:flutter/material.dart';
import 'package:secondflutter/const_cmp.dart';
import 'package:secondflutter/gamecard.dart';
import 'dart:math';

class ResultBarView extends StatelessWidget {
  const ResultBarView(
      {super.key,
        required this.chainResult,});
  final List<ChainResult> chainResult;
  @override
  Widget build(BuildContext context) {
    if (chainResult.length<6) {
      final List<Widget> _widget = List.generate(
          chainResult.length,
              (index) => ResultBar(chainResult: chainResult[index]));
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: _widget,
      );
    }
    return Expanded(
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          padding: const EdgeInsets.all(8),
          itemCount: chainResult.length,
          itemBuilder: (BuildContext context, int index) {
            return ResultBar(chainResult: chainResult[index]);
          }) //listview
      )
    ;
  }
}

class ResultBar extends StatelessWidget {
  const ResultBar({super.key, required this.chainResult});
  final ChainResult chainResult;
  @override
  Widget build(BuildContext context) {
    return Container(
        //margin: const EdgeInsets.only(left: 15.0, right: 15.0),
        width:340,
        child: Card(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
              const Image(
                  image: AssetImage('assets/Chain_Me_Up_Cover_Cost_icon.png'),
                  width: 25),
              Text(chainResult.getCost()),
              const Image(
                  image: AssetImage('assets/Chain_Me_Up_Cover_GHG_icon.png'),
                  width: 25),
              Text(chainResult.getGHG()),
              const Image(
                  image: AssetImage('assets/Chain_Me_Up_Cover_H2O_icon.png'),
                  width: 25),
              Text(chainResult.getH2O()),
              const Image(
                  image: AssetImage('assets/Chain_Me_Up_Cover_land_icon.png'),
                  width: 25),
              Text(chainResult.getLand()),
              const Image(
                  image:
                      AssetImage('assets/Chain_Me_Up_Cover_protest_icon.png'),
                  width: 25),
              Text(chainResult.getProtest()),
              Text(" > ${chainResult.getChallengeresult()}"),
            ])));
  }
}


class DisplaySubmitResultSummary extends StatelessWidget {
  const DisplaySubmitResultSummary({super.key, required this.resultList, required this.fu});
  final List<ChainResult> resultList ;
  final Function fu;
  @override
  Widget build(BuildContext context) {
    String messageDisplay="";
    if (fu()) {
      messageDisplay=" ... searching ...";
    } else {
      if (resultList.isEmpty) {
        messageDisplay=noSuchChain;
      } else {
        if (resultList.length==1){
          messageDisplay="One solution";
          if (resultList[0].getChallengeresult()!=existButNoPerf) {
            messageDisplay+=": ${resultList[0].getChallengeresult()}";}
        } else {
          messageDisplay="${resultList.length} chains";}
      }
    }
    return Center(child:
    Card(
        margin: const EdgeInsets.symmetric(horizontal: 20.0),
        child:SizedBox(
            width: 340,
            height: 32,
            child: Align(
                alignment: Alignment.center,
                child:Text(messageDisplay)
            )
        )
    )
    );
  }
}

class BottomDrawerWidget extends StatelessWidget {
  const BottomDrawerWidget({super.key, required this.resultList, required this.isCollapsed, required this.fuToggle});
  final List<ChainResult> resultList;
  final bool isCollapsed;
  final Function fuToggle;
  @override
  Widget build(BuildContext context) {
    var numberOfResults=resultList.length;
    if (numberOfResults==0) return Container();
    double height =40+min(numberOfResults,6)*32+35;
    double width=MediaQuery.of(context).size.width;
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child : Container(
      color: Colors.blue[700],
      width: width,
      height: height,
      child:Padding(
          padding: const EdgeInsets.symmetric(vertical:2),
          child : Column(
        children: <Widget>[
          GestureDetector(
            onTap: () {fuToggle();},
            child: Icon(isCollapsed ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    size:20,
                    color: Colors.white,
          ),
          ),
          if (!isCollapsed) ResultBarView(chainResult: resultList),
        ],
      )
      )
    )
    );
  }
}



