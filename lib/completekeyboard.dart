import 'package:secondflutter/const_cmp.dart';
import 'package:flutter/material.dart';


class CompleteKeyBoard extends StatelessWidget {
  const CompleteKeyBoard({super.key, required this.fuUpdate, required this.cardSet,
							required this.fuCheck,required this.fuInitCard});
  final Set<int> cardSet ;
  final Function fuUpdate;
  final Function fuCheck;
  final Function fuInitCard;
  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children:<Widget>[
            ButtonKeyBoardPlus(fuCheck:fuCheck, cardSet: cardSet),
            KeyBoard(fu: fuUpdate, cardSet: cardSet, fuInitCard: fuInitCard),
        ]
    );
  }
}


class ButtonKeyBoardPlus extends StatelessWidget {
  const ButtonKeyBoardPlus({super.key, required this.fuCheck, required this.cardSet});
  final Function fuCheck;
  final Set<int> cardSet ;
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 340,
        margin:const EdgeInsets.only(top:15, bottom:0),
        child:ElevatedButton(
              onPressed: () =>  fuCheck(),
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8))),
              //onSurface: Colors.amber,
               child: Text(convCardSet(cardSet))
          )
    )
    ;
  }
}

class CardButton extends StatelessWidget {
  const CardButton({super.key, required this.cardDeckNumber, required this.fu, required this.isPressed});
  final int cardDeckNumber;
  final bool isPressed;
  final Function fu; // function to add the card to the card set, return true if the card is already in it
  @override
  Widget build(BuildContext context) {
    if ((cardDeckNumber+1)>(cardDeck.length)) return Container();
    return Container(
        margin: const EdgeInsets.all(2),
        child : ConstrainedBox(
          constraints: const BoxConstraints.tightFor(width: 30, height: 30),
          child:ElevatedButton(
              onPressed: () {fu(cardDeck[cardDeckNumber].num);},
              style: ElevatedButton.styleFrom(
                  minimumSize: Size.zero, // Set this
                  padding: EdgeInsets.zero, // and this
                  textStyle: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold),
                    backgroundColor: cardDeck[cardDeckNumber].color,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: (isPressed) ? Colors.grey.shade500 : cardDeck[cardDeckNumber].color ,width: 5)
                )
              ),
                child: Text('${cardDeck[cardDeckNumber].num}', style: const TextStyle(color: Colors.white))
          )
      )
    )
    ;
  }
}

class KeyBoard extends StatelessWidget {
  const KeyBoard({super.key, required this.fu, required this.cardSet, required this.fuInitCard});
  final Set<int> cardSet ;
  final Function fuInitCard;
  final Function fu;
  @override
  Widget build(BuildContext context) {
    return Container(
          margin:const EdgeInsets.only(top:15, bottom:15.0),
          width:340,
          child : Align(
              alignment: Alignment.center,
              child:Column(
          children: <Widget>[
            RowKeyBoard(fu: fu, cardSet: cardSet, i0: 0),
            RowKeyBoard(fu: fu, cardSet: cardSet, i0: 10),
            RowKeyBoard(fu: fu, cardSet: cardSet, i0: 20),
            RowKeyBoard(fu: fu, cardSet: cardSet, i0: 30),
            RowKeyBoard(fu: fu, cardSet: cardSet, i0: 40),
            RowKeyBoard(fu: fu, cardSet: cardSet, i0: 50),
            RowKeyBoard(fu: fu, cardSet: cardSet, i0: 60),
            RowKeyBoard(fu: fu, cardSet: cardSet, i0: 70),
            RowKeyBoardLast(fu: fu, cardSet: cardSet, i0: 80, fuInitCard: fuInitCard,),
        ]
      )
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
        mainAxisAlignment: MainAxisAlignment.start,
        children:
          //_widget
          <Widget>[
            ((i0+1)<=cardDeck.length) ? CardButton(cardDeckNumber: i0, fu: fu,isPressed: cardSet.contains(cardDeck[i0].num)) : Container(),
            ((i0+2)<=cardDeck.length) ? CardButton(cardDeckNumber: i0+1, fu: fu,isPressed: cardSet.contains(cardDeck[i0+1].num)) : Container(),
            ((i0+3)<=cardDeck.length) ? CardButton(cardDeckNumber: i0+2, fu: fu,isPressed: cardSet.contains(cardDeck[i0+2].num)) : Container(),
            ((i0+4)<=cardDeck.length) ? CardButton(cardDeckNumber: i0+3, fu: fu,isPressed: cardSet.contains(cardDeck[i0+3].num)) : Container(),
            ((i0+5)<=cardDeck.length) ? CardButton(cardDeckNumber: i0+4, fu: fu,isPressed: cardSet.contains(cardDeck[i0+4].num)) : Container(),
            ((i0+6)<=cardDeck.length) ? CardButton(cardDeckNumber: i0+5, fu: fu,isPressed: cardSet.contains(cardDeck[i0+5].num)) : Container(),
            ((i0+7)<=cardDeck.length) ? CardButton(cardDeckNumber: i0+6, fu: fu,isPressed: cardSet.contains(cardDeck[i0+6].num)) : Container(),
            ((i0+8)<=cardDeck.length) ? CardButton(cardDeckNumber: i0+7, fu: fu,isPressed: cardSet.contains(cardDeck[i0+7].num)) : Container(),
            ((i0+9)<=cardDeck.length) ? CardButton(cardDeckNumber: i0+8, fu: fu,isPressed: cardSet.contains(cardDeck[i0+8].num)) : Container(),
            ((i0+10)<=cardDeck.length) ? CardButton(cardDeckNumber: i0+9, fu: fu,isPressed: cardSet.contains(cardDeck[i0+9].num)) : Container(),
        ]
    );
  }
}

class RowKeyBoardLast extends StatelessWidget {
  const RowKeyBoardLast({super.key, required this.fu, required this.cardSet, required this.i0, required this.fuInitCard});
  final Set<int> cardSet ;
  final Function fu;
  final Function fuInitCard;
  final int i0;
  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children:
        //_widget
        <Widget>[
          ((i0+1)<=cardDeck.length) ? CardButton(cardDeckNumber: i0, fu: fu,isPressed: cardSet.contains(cardDeck[i0].num)) : Container(),
          ((i0+2)<=cardDeck.length) ? CardButton(cardDeckNumber: i0+1, fu: fu,isPressed: cardSet.contains(cardDeck[i0+1].num)) : Container(),
          ((i0+3)<=cardDeck.length) ? CardButton(cardDeckNumber: i0+2, fu: fu,isPressed: cardSet.contains(cardDeck[i0+2].num)) : Container(),
          ((i0+4)<=cardDeck.length) ? CardButton(cardDeckNumber: i0+3, fu: fu,isPressed: cardSet.contains(cardDeck[i0+3].num)) : Container(),
          ((i0+5)<=cardDeck.length) ? CardButton(cardDeckNumber: i0+4, fu: fu,isPressed: cardSet.contains(cardDeck[i0+4].num)) : Container(),
          //((i0+6)<cardDeck.length) ? CardButton(cardDeckNumber: i0+5, fu: fu,isPressed: cardSet.contains(cardDeck[i0+5].num)) : Container(),
          //((i0+7)<cardDeck.length) ? CardButton(cardDeckNumber: i0+6, fu: fu,isPressed: cardSet.contains(cardDeck[i0+6].num)) : Container(),
          //((i0+8)<cardDeck.length) ? CardButton(cardDeckNumber: i0+7, fu: fu,isPressed: cardSet.contains(cardDeck[i0+7].num)) : Container(),
          //((i0+9)<cardDeck.length) ? CardButton(cardDeckNumber: i0+8, fu: fu,isPressed: cardSet.contains(cardDeck[i0+8].num)) : Container(),
          //((i0+10)<cardDeck.length) ? CardButton(cardDeckNumber: i0+9, fu: fu,isPressed: cardSet.contains(cardDeck[i0+9].num)) : Container(),
          Container(width:71),
          ConstrainedBox(
            constraints: const BoxConstraints.tightFor(width: 97, height: 30),
            child: ElevatedButton(
                  onPressed: () => fuInitCard(),
                  style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8))
                    ),
                  child:const Text("clear")
            ),
          )
        ]
    );
  }
}

String convCardSet (Set<int> cardSet) {
  if (cardSet.isEmpty) return "";
  String stringToCheck="";
  List<int> toSort=List<int>.from(cardSet);
  toSort.sort();
  for(int i in toSort){
    stringToCheck += "-${i.toString().padLeft(2, '0')}";
  }
  return stringToCheck.substring(1);
}