import 'package:what_when_where/db_chgk_info/cache/tour_cache.dart';
import 'package:what_when_where/db_chgk_info/cache/tournament_cache.dart';
import 'package:what_when_where/db_chgk_info/http_client.dart';
import 'package:what_when_where/db_chgk_info/models/tour.dart';
import 'package:what_when_where/db_chgk_info/models/tournament.dart';

class TournamentDetailsLoader {
  static final TournamentDetailsLoader _instance =
      TournamentDetailsLoader._internal();

  factory TournamentDetailsLoader() => _instance;

  TournamentDetailsLoader._internal();

  final _cache = TournamentCache();
  final _toursCache = TourCache();

  Future<Tournament> get(String id) async {
    if (_cache.contains(id)) {
      return _cache.get(id);
    }

    var map = await HttpClient().get(Uri(path: '/tour/$id/xml'));
    map = map['tournament'];

    _handleTourlessTournament(map);

    final tournament = Tournament.fromJson(map);
    _cache.save(tournament);
    return tournament;
  }

  void _handleTourlessTournament(Map<String, dynamic> map) {
    if (!map.containsKey('tour')) {
      final tourMap = Map<String, dynamic>.from(map);
      tourMap['ParentId'] = map['Id'];

      final tour = Tour.fromJson(tourMap);
      _toursCache.save(tour);

      map['tour'] = tourMap;
    }
  }
}
