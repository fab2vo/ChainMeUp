import 'package:secondflutter/const_cmp.dart';
import 'package:flutter/material.dart';
import 'package:secondflutter/gamecard.dart';

class CompleteKeyBoard extends StatelessWidget {
  const CompleteKeyBoard({super.key, required this.fupdate, required this.cardSet, 
							required this.withbuttons, required this.fucheck, 
							required this.initcard, required this.isShortened});
  final Set<int> cardSet ;
  final Function fupdate;
  final Function fucheck;
  final Function initcard;
  final bool withbuttons;
  final bool isShortened;
  @override
  Widget build(BuildContext context) {
    if (isShortened) return Container();
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children:<Widget>[
            KeyBoard(fu: fupdate, cardSet: cardSet),
			      ButtonKeyBoard(withbuttons:withbuttons,fucheck:fucheck, initcard:initcard)
        ]
    );
  }
}

class ButtonKeyBoard extends StatelessWidget {
  const ButtonKeyBoard({super.key, required this.withbuttons, required this.fucheck, required this.initcard});
  final Function fucheck; 
  final Function initcard;
  final bool withbuttons; 
  @override
  Widget build(BuildContext context) {
    return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () => withbuttons ? fucheck():null,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8))),
					              //onSurface: Colors.amber,
                  child: const Text('Submit')
                  ),
                  ElevatedButton(
                      onPressed: () => initcard(),
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8))),
                      child: const Text('Clear')
                  ),
                  ]
            );
  }
}

class CardButton extends StatelessWidget {
  const CardButton({super.key, required this.carddecknumber, required this.fu, required this.isPressed});
  final int carddecknumber;
  final bool isPressed;
  final Function fu; // function to add the card to the card set, return true if the card is already in it
  @override
  Widget build(BuildContext context) {
    if ((carddecknumber+1)>(cardDeck.length)) return Container();
    return Container(
        margin: const EdgeInsets.all(2),
        child : ConstrainedBox(
          constraints: const BoxConstraints.tightFor(width: 30, height: 30),
          child:ElevatedButton(
              onPressed: () {fu(cardDeck[carddecknumber].num);},
              style: ElevatedButton.styleFrom(
                  minimumSize: Size.zero, // Set this
                  padding: EdgeInsets.zero, // and this
                  textStyle: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold),
                    backgroundColor: cardDeck[carddecknumber].color,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: (isPressed) ? Colors.grey.shade500 : cardDeck[carddecknumber].color ,width: 5)
                )
              ),
                child: Text('${cardDeck[carddecknumber].num}', style: const TextStyle(color: Colors.white))
          )
      )
    )
    ;
  }
}

class KeyBoard extends StatelessWidget {
  const KeyBoard({super.key, required this.fu, required this.cardSet});
  final Set<int> cardSet ;
  final Function fu;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin:const EdgeInsets.only(top:15, bottom:15.0),
      child : Column(
        children: <Widget>[
        RowKeyBoard(fu: fu, cardSet: cardSet, i0: 0),
        RowKeyBoard(fu: fu, cardSet: cardSet, i0: 10),
        RowKeyBoard(fu: fu, cardSet: cardSet, i0: 20),
        RowKeyBoard(fu: fu, cardSet: cardSet, i0: 30),
        RowKeyBoard(fu: fu, cardSet: cardSet, i0: 40),
        RowKeyBoard(fu: fu, cardSet: cardSet, i0: 50),
        RowKeyBoard(fu: fu, cardSet: cardSet, i0: 60),
        RowKeyBoard(fu: fu, cardSet: cardSet, i0: 70),
        RowKeyBoard(fu: fu, cardSet: cardSet, i0: 80),
          //Text(convCardSet(cardSet),style: TextStyle(fontSize: 18)),
        ]
      )
    )
    ;
  }
}

class RowKeyBoard extends StatelessWidget {
  const RowKeyBoard({super.key, required this.fu, required this.cardSet, required this.i0});
  final Set<int> cardSet ;
  final Function fu;
  final int i0;
  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children:
          //_widget
          <Widget>[
            ((i0+1)<cardDeck.length) ? CardButton(carddecknumber: i0, fu: fu,isPressed: cardSet.contains(cardDeck[i0].num)) : Container(),
            ((i0+2)<cardDeck.length) ? CardButton(carddecknumber: i0+1, fu: fu,isPressed: cardSet.contains(cardDeck[i0+1].num)) : Container(),
            ((i0+3)<cardDeck.length) ? CardButton(carddecknumber: i0+2, fu: fu,isPressed: cardSet.contains(cardDeck[i0+2].num)) : Container(),
            ((i0+4)<cardDeck.length) ? CardButton(carddecknumber: i0+3, fu: fu,isPressed: cardSet.contains(cardDeck[i0+3].num)) : Container(),
            ((i0+5)<cardDeck.length) ? CardButton(carddecknumber: i0+4, fu: fu,isPressed: cardSet.contains(cardDeck[i0+4].num)) : Container(),
            ((i0+6)<cardDeck.length) ? CardButton(carddecknumber: i0+5, fu: fu,isPressed: cardSet.contains(cardDeck[i0+5].num)) : Container(),
            ((i0+7)<cardDeck.length) ? CardButton(carddecknumber: i0+6, fu: fu,isPressed: cardSet.contains(cardDeck[i0+6].num)) : Container(),
            ((i0+8)<cardDeck.length) ? CardButton(carddecknumber: i0+7, fu: fu,isPressed: cardSet.contains(cardDeck[i0+7].num)) : Container(),
            ((i0+9)<cardDeck.length) ? CardButton(carddecknumber: i0+8, fu: fu,isPressed: cardSet.contains(cardDeck[i0+8].num)) : Container(),
            ((i0+10)<cardDeck.length) ? CardButton(carddecknumber: i0+9, fu: fu,isPressed: cardSet.contains(cardDeck[i0+9].num)) : Container(),
        ]
    );
  }
}
