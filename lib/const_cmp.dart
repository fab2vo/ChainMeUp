import 'package:flutter/material.dart';
import 'package:secondflutter/gamecard.dart';

Color colH2H2=Colors.amber.shade600;
Color colElec=Colors.blue;
Color colComc=Colors.green.shade700;
Color colTran=Colors.blue.shade900;
Color colStor=Colors.grey.shade900;
Color colHeat=Colors.red.shade800;
final cardDeck=[ GameCard(02,colH2H2),GameCard(03,colH2H2),GameCard(04,colH2H2),GameCard(05,colH2H2),GameCard(06,colH2H2),GameCard(10,colH2H2),GameCard(11,colH2H2),GameCard(12,colH2H2),GameCard(13,colH2H2),
                 GameCard(14,colH2H2),GameCard(15,colH2H2),GameCard(16,colH2H2),GameCard(17,colH2H2),GameCard(18,colH2H2),GameCard(19,colH2H2),GameCard(20,colElec),GameCard(21,colElec),GameCard(22,colElec),
                 GameCard(23,colElec),GameCard(24,colElec),GameCard(25,colElec),GameCard(26,colElec),GameCard(27,colElec),GameCard(28,colElec),GameCard(29,colElec),GameCard(30,colElec),GameCard(31,colElec),
                 GameCard(32,colElec),GameCard(33,colElec),GameCard(36,colElec),GameCard(37,colElec),GameCard(38,colElec),GameCard(39,colComc),GameCard(40,colComc),GameCard(41,colComc),GameCard(42,colComc),
                 GameCard(43,colComc),GameCard(44,colComc),GameCard(45,colComc),GameCard(46,colComc),GameCard(47,colComc),GameCard(48,colComc),GameCard(49,colComc),GameCard(50,colComc),GameCard(51,colComc),
                 GameCard(52,colComc),GameCard(53,colComc),GameCard(54,colComc),GameCard(55,colComc),GameCard(56,colComc),GameCard(57,colTran),GameCard(58,colTran),GameCard(59,colTran),GameCard(60,colTran),
                 GameCard(61,colTran),GameCard(62,colTran),GameCard(63,colTran),GameCard(64,colTran),GameCard(65,colTran),GameCard(66,colTran),GameCard(67,colTran),GameCard(68,colTran),GameCard(69,colTran),GameCard(70,colTran),
                 GameCard(71,colTran),GameCard(72,colTran),GameCard(73,colTran),GameCard(74,colTran),GameCard(75,colTran),GameCard(76,colTran),GameCard(77,colStor),GameCard(78,colStor),GameCard(79,colStor),
                 GameCard(80,colStor),GameCard(81,colStor),GameCard(82,colStor),GameCard(83,colStor),GameCard(84,colStor),GameCard(85,colStor),GameCard(86,colStor),GameCard(87,colHeat),GameCard(88,colHeat),
                 GameCard(89,colHeat),GameCard(90,colHeat),GameCard(93,colHeat),
];
const String noSuchChain="No chain for this card set";
const String existButNoPerf="";
const String lowEmission="Low emission";
const String susTainable="Sustainable";
const String massiveSustainable="Large Sust.";
const String netZero="Large Net0";
