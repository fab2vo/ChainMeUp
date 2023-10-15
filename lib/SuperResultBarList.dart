import 'package:flutter/material.dart';
import 'package:secondflutter/gamecard.dart';

class SuperResultBarList extends StatelessWidget {
  const SuperResultBarList(
      {super.key,
        required this.chainResList,
        required this.nMax,
        required this.isShort,
        required this.fuTog});
  final List<ChainResult> chainResList;
  final int nMax;
  final bool isShort;
  final Function fuTog;
  @override
  Widget build(BuildContext context) {
    if (isShort) {
      return ResultBarList(
          chainResList: chainResList, nMax: 6, fuTog: fuTog);
    }
    return ResultBarListView(chainResList: chainResList, fuTog: fuTog);
  }
}

class ResultBarList extends StatelessWidget {
  const ResultBarList(
      {super.key,
        required this.chainResList,
        required this.nMax,
        required this.fuTog});
  final List<ChainResult> chainResList;
  final int nMax;
  final Function fuTog;
  @override
  Widget build(BuildContext context) {
    final List<Widget> _widget = List.generate(
        (chainResList.length <= nMax) ? chainResList.length : nMax,
            (index) => ResultBar(chainResult: chainResList[index]));
    if (chainResList.length > nMax) {
      _widget.add(GestureDetector(
        onTap: () => fuTog(),
        child:
        Card(child: Text(" ${chainResList.length - nMax} more results ")),
      ) // gesture
      ); //add widget
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: _widget,
    );
  }
}

class ResultBarListView extends StatelessWidget {
  const ResultBarListView(
      {super.key,
        required this.chainResList,
        required this.fuTog});
  final List<ChainResult> chainResList;
  final Function fuTog;
  @override
  Widget build(BuildContext context) {
    return
      //GestureDetector(onTap: null,
      //  child:
        Expanded(child:
          ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            padding: const EdgeInsets.all(8),
            itemCount: chainResList.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(onTap:() => fuTog(),child:
                ResultBar(chainResult: chainResList[index])
              );
            }) //listview
        )
      //)
    ;
  }
}

class ResultBar extends StatelessWidget {
  const ResultBar({super.key, required this.chainResult});
  final ChainResult chainResult;
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(left: 15.0, right: 15.0),
        child: Card(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
              const Image(
                  image: AssetImage('assets/Chain_Me_Up_Cover_Cost_icon.png'),
                  width: 30),
              Text(chainResult.getCost()),
              const Image(
                  image: AssetImage('assets/Chain_Me_Up_Cover_GHG_icon.png'),
                  width: 30),
              Text(chainResult.getGHG()),
              const Image(
                  image: AssetImage('assets/Chain_Me_Up_Cover_H2O_icon.png'),
                  width: 30),
              Text(chainResult.getH2O()),
              const Image(
                  image: AssetImage('assets/Chain_Me_Up_Cover_land_icon.png'),
                  width: 30),
              Text(chainResult.getLand()),
              const Image(
                  image:
                      AssetImage('assets/Chain_Me_Up_Cover_protest_icon.png'),
                  width: 30),
              Text(chainResult.getProtest()),
              Text(" > ${chainResult.getChallengeresult()}"),
            ])));
  }
}

class StringDisplayCard extends StatelessWidget {
  const StringDisplayCard(
      {super.key, required this.theString, required this.isShortened});
  final String theString;
  final bool isShortened;
  @override
  Widget build(BuildContext context) {
    if (theString.isEmpty || isShortened) {
      return Container();
    }
    return Card(child: Text(theString));
  }
}
