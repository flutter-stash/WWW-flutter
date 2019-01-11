import 'package:flutter/material.dart';
import 'package:what_when_where/db_chgk_info/models/tour.dart';
import 'package:what_when_where/resources/dimensions.dart';
import 'package:what_when_where/ui/tour_questions/question_card.dart';

class TourQuestionsPage extends StatefulWidget {
  final Tour tour;
  final int startIndex;

  TourQuestionsPage({Key key, @required this.tour, this.startIndex})
      : assert(tour != null),
        assert(tour.questions != null),
        super(key: key);

  @override
  createState() => _TourQuestionsPageState(tour: tour, startIndex: startIndex);
}

class _TourQuestionsPageState extends State<TourQuestionsPage> {
  final Tour tour;
  final int _startIndex;

  _TourQuestionsPageState({@required this.tour, int startIndex})
      : this._startIndex = startIndex;

  @override
  Widget build(BuildContext context) => Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.timer,
          ),
          onPressed: () {},
        ),
        appBar: AppBar(
          backgroundColor: Theme.of(context).canvasColor,
          iconTheme: Theme.of(context).iconTheme,
          elevation: 0.0,
        ),
        bottomNavigationBar: BottomAppBar(
            color: Theme.of(context).primaryColor,
            child: IconTheme(
              data: Theme.of(context).primaryIconTheme,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.defaultSidePadding * 2),
                    child: Text(
                      '0:00',
                      style: Theme.of(context).primaryTextTheme.title,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.more_vert),
                    onPressed: () {},
                  ),
                ],
              ),
            )),
        body: PageView.builder(
          controller:
              PageController(initialPage: _startIndex, viewportFraction: 0.85),
          itemBuilder: (context, index) => Padding(
              padding: EdgeInsets.only(bottom: kToolbarHeight),
              child: QuestionCard(
                question: tour.questions[index],
              )),
          itemCount: tour.questions.length,
        ),
      );
}
