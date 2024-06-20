import 'package:flutter/material.dart';
import '../models/scorecard.dart';
import '../models/dice.dart';

class BuildScoreCardWidget extends StatefulWidget {
  final ScoreCard scoreCard;
  final ScoreCategory? selectedCategory;
  final Function(ScoreCategory) onTapCategory;
  final List<int> selectedValues;
  final VoidCallback resetDice;
  final Dice diceSelected;


  BuildScoreCardWidget({super.key,
    required this.scoreCard,
    required this.selectedCategory,
    required this.onTapCategory,
    required this.selectedValues,
    required this.resetDice,
    required this.diceSelected,
  });

  @override
  _BuildScoreCardWidgetState createState() => _BuildScoreCardWidgetState(selectedValues: selectedValues);
}

class _BuildScoreCardWidgetState extends State<BuildScoreCardWidget> {
  final List<int> selectedValues;

  _BuildScoreCardWidgetState({required this.selectedValues});

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        buildScoreCardGrid(), // buildScoreCardGrid is a gridview widget for displaying the scoreCard
        const SizedBox(height: 15),
        buildTotalScore(), // buildTotalScore is placed at the bottom of the page, below the scoreCard widget
      ],
    );
  }

  Widget buildScoreCardGrid() {
    return GridView.builder( // specifications for how the grid must be displayed
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        childAspectRatio: 2.0,
        mainAxisSpacing: 20.0,
        crossAxisSpacing: 20.0,
      ),
      itemCount: ScoreCategory.values.length,
      itemBuilder: (BuildContext context, int index) {
        final category = ScoreCategory.values[index];
        final hasValue = widget.scoreCard[category] != null;
        return buildScoreCardItem(category, hasValue);
      },
    );
  }

  Widget buildScoreCardItem(ScoreCategory category, bool hasValue) {
    return GestureDetector(
      onTap: () {
        widget.onTapCategory(category);
      },
      child: Card(
        elevation: 2.0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(category.name),
              const SizedBox(height: 5.0),
              buildStoreValueButton(category, hasValue),
              Visibility(
                visible: hasValue,
                child: Text(
                  hasValue ? '${widget.scoreCard[category]}' : 'Score: -',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildStoreValueButton(ScoreCategory category, bool hasValue) {
    return  Visibility(
      visible: !hasValue,
      child: ElevatedButton(
        onPressed: () {
          if(widget.diceSelected.values.isNotEmpty) { // if the diceSelected array has any values, then register the score in that widget
            widget.onTapCategory(category);
            widget.scoreCard.registerScore(category, widget.diceSelected.values);
            
            setState(() { // as soon as a score has been stored, clear the selectedValues array since other values will be pushed in the next turn, clear the selectedDicees array and reset the dice entirely
              selectedValues.clear();
              widget.diceSelected.clear();
              widget.resetDice();
            });
          }
        },
        child: const Text('Store Value'),
      ),
    );
  }

  Widget buildTotalScore() {
    return Center(
      child: Text(
        'Total Score: ${widget.scoreCard.total}',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
        ),
      ),
    );
  }
}