import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:what_when_where/redux/app/state.dart';
import 'package:what_when_where/redux/tornament/actions.dart';
import 'package:what_when_where/redux/tornament/state.dart';
import 'package:what_when_where/ui/common/error_message.dart';
import 'package:what_when_where/ui/common/progress_indicator.dart';
import 'package:what_when_where/ui/tournament_details/tournament_details_body.dart';
import 'package:what_when_where/ui/tournament_details/tournament_details_header.dart';

@immutable
class TournamentDetailsPage extends StatefulWidget {
  static const String routeName = 'tournament';

  @override
  _TournamentDetailsPageState createState() => _TournamentDetailsPageState();
}

class _TournamentDetailsPageState extends State<TournamentDetailsPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Material(
            color: Colors.transparent,
            child: _buildBody(context),
          ),
        ),
      ));

  Widget _buildBody(BuildContext context) =>
      StoreConnector<AppState, TournamentState>(
        distinct: true,
        converter: (store) => store.state.tournamentState,
        builder: (context, state) {
          if (state.isLoading) {
            return const _LoadingTournamentDetailsPage();
          }
          if (state.hasError) {
            return _ErrorTournamentDetailsPage(
              exception: state.exception,
            );
          }
          if (state.hasData) {
            return TournamentDetailsBody(count: state.tournament.tours.length);
          }
          return Container();
        },
        onDispose: (store) => store.dispatch(const VoidTournament()),
      );
}

class _LoadingTournamentDetailsPage extends StatelessWidget {
  const _LoadingTournamentDetailsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          _ElevatedHeader(),
          Expanded(child: WWWProgressIndicator())
        ],
      );
}

class _ErrorTournamentDetailsPage extends StatelessWidget {
  final Exception exception;

  const _ErrorTournamentDetailsPage({
    Key key,
    this.exception,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _ElevatedHeader(),
          Expanded(
              child: ErrorMessage(
                  exception: exception,
                  retryFunction: () => _loadTournament(context),
                  color: Theme.of(context).primaryColor))
        ],
      );

  void _loadTournament(BuildContext context) =>
      StoreProvider.of<AppState>(context).dispatch(const ReloadTournament());
}

class _ElevatedHeader extends StatelessWidget {
  const _ElevatedHeader({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => PhysicalModel(
        elevation: 4.0,
        color: Theme.of(context).primaryColor,
        child: const TournamentDetailsPageHeader(),
      );
}
