import 'package:secondflutter/const_cmp.dart';
import 'package:flutter/material.dart';
import 'package:secondflutter/gamecard.dart';


class ResultBar extends StatelessWidget{
  const ResultBar({super.key, required this.chainresult});
  final ChainResult chainresult;
    @override
  Widget build(BuildContext context) {
    return Container(
        margin:const EdgeInsets.only(left:15.0, right:15.0),
        child : Card(child:Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children :<Widget>[
            const Image(image:AssetImage('assets/Chain_Me_Up_Cover_Cost_icon.png'), width:30),
            Text(chainresult.getCost()),
            const Image(image:AssetImage('assets/Chain_Me_Up_Cover_GHG_icon.png'), width:30),
            Text(chainresult.getGHG()),
            const Image(image:AssetImage('assets/Chain_Me_Up_Cover_H2O_icon.png'), width:30),
            Text(chainresult.getH2O()),
            const Image(image:AssetImage('assets/Chain_Me_Up_Cover_land_icon.png'), width:30),
            Text(chainresult.getLand()),
            const Image(image:AssetImage('assets/Chain_Me_Up_Cover_protest_icon.png'), width:30),
            Text(chainresult.getProtest()),
            Text(" > ${chainresult.getChallengeresult()}"),
        ]
      )
        )
    );
  }
}

class ResultBarList extends StatelessWidget{
  const ResultBarList({super.key, required this.chainresultlist, required this.nummaxitem,required this.futogglescreen});
  final List<ChainResult> chainresultlist;
  final nummaxitem;
  final Function futogglescreen; 
  @override
  Widget build(BuildContext context) { 
  final List<Widget> _widget = List.generate(
      (chainresultlist.length<=nummaxitem)? chainresultlist.length : nummaxitem,
        (index) => ResultBar(chainresult: chainresultlist[index] )
    );
  if (chainresultlist.length>nummaxitem){
    _widget.add(
		GestureDetector(
			onTap:()=>futogglescreen,
			child:Text(" ${chainresultlist.length-nummaxitem} more results "),
		) // gesture
	); //add widget
  }
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    children: _widget,
    );
  }
}

class ResultBarListView extends StatelessWidget{
  const ResultBarListView({super.key, required this.chainresultlist, required this.futogglescreen});
  final List<ChainResult> chainresultlist;
  final Function futogglescreen;
  @override
  Widget build(BuildContext context) {
  return GestureDetector(
	onTap:futogglescreen(),
	child: ListView.builder(
		padding: const EdgeInsets.all(8),
		itemCount: chainresultlist.length,
		itemBuilder: (BuildContext context, int index) {
		return ResultBar(chainresult:chainresultlist[index]);
		}
	) //listview
  ); //gesture
  }
}

class SuperResultBarList extends StatelessWidget{
  const SuperResultBarList({super.key, required this.chainresultlist, required this.nummaxitem, required this.isshort, required this.futogglescreen});
  final List<ChainResult> chainresultlist;
  final int nummaxitem;
  final bool isshort;
  final Function futogglescreen;  
  @override
  Widget build(BuildContext context) {
    if (isshort) { return ResultBarList(chainresultlist:chainresultlist, nummaxitem:6, futogglescreen:futogglescreen);}
    return Container(
    );
  }
}

class StringDisplayCard extends StatelessWidget{
  const StringDisplayCard({super.key, required this.thestring, required this.isShortened});
  final String thestring;
  final bool isShortened;
  @override
  Widget build(BuildContext context) {
    if (thestring!= null || thestring.isNotEmpty || isShortened) { return Container();}
    return Card(
		child: Text(thestring)
    );
  }
}