// import 'dart:math';
// ignore_for_file: unnecessary_null_comparison, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:mp2/views/buildScoreCardWidget.dart';
import 'package:mp2/views/diceBox.dart';
import '../models/dice.dart';
import '../models/scorecard.dart';

class Yahtzee extends StatelessWidget {
  const Yahtzee({super.key});

  @override
  Widget build(BuildContext context) {
    return 
        Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: pageOneContent(context), // pageOneContent is the homepage of the game
          ),
        );
  }
}

Center pageOneContent(context) => Center(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Text("Yahtzee", style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
      Center(
        child: TextButton(
          style: const ButtonStyle(alignment: Alignment.centerLeft),
          onPressed: () {
            Navigator.of(context).push( // implemented Navigator for the second page to be pushed into the navigator
              MaterialPageRoute(
                builder: (context) {
                  return const YahtzeeGame();
                }
              ),
            );
          },
          child: const Text('Play game'),
        ),
      )
    ],
  ),
);

class YahtzeeGame extends StatefulWidget {
  const YahtzeeGame({super.key});

  @override
  _YahtzeeGame createState() => _YahtzeeGame();
}

class _YahtzeeGame extends State<YahtzeeGame> {
  final Dice diceSelected = Dice(5);
  int diceRolled = 0;
  bool diceBoxesVisible = true;
  final ScoreCard scoreCard = ScoreCard();
  ScoreCategory? selectedCategory;
  List<int> selectedValues = [];

  @override
  void initState() { // initState for the entire game which will clear the dices intially.
    super.initState();
    diceSelected.clear();
  }

  void handleCategorySelection(ScoreCategory category) { // handle the selected category
    if (scoreCard[category] == null) {
      setState(() {
        selectedCategory = category;
      });
    }
  }

  void resetDice() { // resetDice method handles the selected dice boxes to be reset and set the roll dice button to 0
    setState(() {
      diceSelected.clear();
      diceRolled = 0;
    });
    if (scoreCard.completed) { // if all of the scoreCards has been selected, display a dialog box displaying the score
      showTotalScoreDialog();
    }
  }

  void showTotalScoreDialog() { // dialog box after the scoreCards has been selected
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Total Score'),
          content: Text('Your total score is: ${scoreCard.total}'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                resetGame();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void resetGame() { // resetGame implements the game to be entirely reset when the OK is clicked in the dialog box
    setState(() {
      diceSelected.clear();
      diceRolled = 0;
      scoreCard.clear();
      selectedCategory = null;
      selectedValues.clear();
    });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Let's Play Yahtzee!"), centerTitle: true,),
      body: Align(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 25),
            Row( // first row in the column is to display the 5 dice boxes
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: diceBoxRow(), // being called to dicebox.dart file
            ),
            const SizedBox(height: 15),
            Row( // second die is for the roll dice button which has a set state for rolling the dice and incrementing the value of diceRolled variable to check if 3 rolls has been rolled or not
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: diceRolled < 3 ? () {
                    setState(() {
                      diceSelected.roll();
                      diceRolled++;
                    });
                  } : null,
                  child: Text("Roll Dice ($diceRolled)"),
                ),
              ],
            ),
            const SizedBox(height: 100),
            Center( // buildScoreCardWidget builds the scoreCard widget with all of the categories and the respective Store Value button in each of the categories
              child: BuildScoreCardWidget(
                scoreCard: scoreCard,
                selectedCategory: selectedCategory,
                onTapCategory: handleCategorySelection,
                selectedValues: selectedValues,
                resetDice: resetDice,
                diceSelected: diceSelected,
              ),
            )
          ],
        ),
      ),
    );
  }

  List<Widget> diceBoxRow() {
    List<Widget> diceWidgets = [];
    if(diceSelected.values.isEmpty) {
      for (int i = 0; i < 5; i++) {
        diceWidgets.add(DiceBox( // display empty values initally and push the selected values to diceWidgets array
          value: null,
          isHeld: false,
          onTap: () {},
        ));
      }
    } else {
      for (int i = 0; i < diceSelected.values.length; i++) {
        diceWidgets.add(DiceBox( // hold the values which has been selected and the values that are being helf and also toggle hold the selected dice box and push the selected values to diceWidgets array
          value: diceSelected.values[i],
          isHeld: diceSelected.isHeld(i),
          onTap: () {
            setState(() {
              diceSelected.toggleHold(i);
              if (!diceSelected.isHeld(i)) {
                selectedValues.remove(diceSelected.values[i]);
              } else {
                selectedValues.add(diceSelected.values[i]);
              }
            });
          },
        ));  
      }
    }
    return diceWidgets;
  }
}