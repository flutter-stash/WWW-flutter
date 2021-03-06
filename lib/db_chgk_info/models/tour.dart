import 'dart:collection';

import 'package:meta/meta.dart';
import 'package:what_when_where/constants.dart';
import 'package:what_when_where/db_chgk_info/models/question.dart';
import 'package:what_when_where/utils/texts.dart';

@immutable
class Tour {
  final String id;
  final String parentId;
  final String title;
  final String number;
  final String questionsCount;
  final String tournamentTitle;
  final String description;
  final String url;
  final String editors;
  final String createdAt;
  final String playedAt;
  final UnmodifiableListView<Question> questions;

  const Tour({
    this.id,
    this.parentId,
    this.title,
    this.number,
    this.questionsCount,
    this.tournamentTitle,
    this.description,
    this.url,
    this.editors,
    this.createdAt,
    this.playedAt,
    this.questions,
  });

  factory Tour.fromJson(Map<String, dynamic> map) => Tour(
        id: map['Id'],
        parentId: map['ParentId'],
        title: map['Title'],
        number: map['Number'],
        questionsCount: map['QuestionsNum'],
        tournamentTitle: map['tournamentTitle'],
        description: TextUtils.normalizeToSingleLine(map['Info']),
        url: '${Constants.databaseUrl}/tour/${map['Id']}',
        editors: TextUtils.normalizeToSingleLine(map['Editors']),
        createdAt: map['CreatedAt'],
        playedAt: map['PlayedAt'],
        questions: map.containsKey('question')
            ? map['question'] is List
                ? UnmodifiableListView(
                    List<Map<String, dynamic>>.from(map['question'])
                        .map((q) => Question.fromJson(q))
                        .toList())
                : UnmodifiableListView([Question.fromJson(map['question'])])
            : UnmodifiableListView([]),
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'Id': id,
        'ParentId': parentId,
        'Title': title,
        'Number': number,
        'QuestionsNum': questionsCount,
        'tournamentTitle': tournamentTitle,
        'Info': description,
        'Editors': editors,
        'CreatedAt': createdAt,
        'PlayedAt': playedAt,
      };
}
