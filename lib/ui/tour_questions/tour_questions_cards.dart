import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:what_when_where/redux/app/state.dart';
import 'package:what_when_where/redux/questions/actions.dart';
import 'package:what_when_where/redux/questions/state.dart';
import 'package:what_when_where/redux/timer/actions.dart';
import 'package:what_when_where/ui/common/progress_indicator.dart';
import 'package:what_when_where/ui/question/question_card.dart';
import 'package:what_when_where/ui/tour_questions/error_message.dart';

class TourQuestionsCards extends StatelessWidget {
  static const _viewportFraction = 0.85;

  const TourQuestionsCards({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      StoreConnector<AppState, QuestionsState>(
        distinct: true,
        converter: (store) => store.state.questionsState,
        builder: (context, state) {
          final count = state.questions.length;
          final startIndex = state.currentQuestionIndex;
          final isLoading = state.isLoading;
          final hasError = state.hasError;
          final hasAdditionalCard = isLoading || hasError;

          return PageView.builder(
            controller: PageController(
              initialPage: startIndex,
              viewportFraction: _viewportFraction,
            ),
            itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.only(bottom: kToolbarHeight),
                  child: hasAdditionalCard && index == count
                      ? isLoading
                          ? const WWWProgressIndicator()
                          : const QuestionsErrorMessage()
                      : QuestionCard(index: index),
                ),
            itemCount: hasAdditionalCard ? count + 1 : count,
            onPageChanged: (index) => _onPageChanged(context, index),
          );
        },
      );

  void _onPageChanged(BuildContext context, int index) {
    final store = StoreProvider.of<AppState>(context);

    store.dispatch(const ResetTimer());
    store.dispatch(SelectQuestion(index));
  }
}
