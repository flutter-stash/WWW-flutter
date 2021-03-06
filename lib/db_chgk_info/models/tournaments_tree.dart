import 'dart:collection';

import 'package:meta/meta.dart';
import 'package:what_when_where/db_chgk_info/models/tournament.dart';

@immutable
class TournamentsTree {
  final String id;
  final String title;
  final String childrenCount;
  final UnmodifiableListView<dynamic> children;

  const TournamentsTree({
    this.id,
    this.title,
    this.childrenCount,
    this.children,
  });

  factory TournamentsTree.fromJson(Map<String, dynamic> map) => TournamentsTree(
        id: map['Id'],
        title: map['Title']?.trim(),
        childrenCount: map['ChildrenNum'],
        children: map.containsKey('tour')
            ? map['tour'] is List
                ? UnmodifiableListView<dynamic>(
                    List<Map<String, dynamic>>.from(map['tour'])
                        .map<dynamic>(_getTreeItem)
                        .toList(),
                  )
                : UnmodifiableListView<dynamic>(<dynamic>[
                    _getTreeItem(map['tour']),
                  ])
            : UnmodifiableListView<dynamic>(<dynamic>[]),
      );

  static dynamic _getTreeItem(Map<String, dynamic> map) =>
      map.containsKey('Type')
          ? map['Type'] == 'Г'
              ? TournamentsTree.fromJson(map)
              : Tournament.fromJson(map)
          : null;
}
