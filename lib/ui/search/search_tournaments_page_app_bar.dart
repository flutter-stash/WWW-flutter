import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:rxdart/subjects.dart';
import 'package:what_when_where/redux/app/state.dart';
import 'package:what_when_where/redux/search/actions.dart';
import 'package:what_when_where/redux/search/state.dart';
import 'package:what_when_where/resources/strings.dart';
import 'package:what_when_where/ui/search/sorting_button.dart';

class SearchTournamentsPageAppBar extends StatefulWidget
    implements PreferredSizeWidget {
  final ScrollController scrollController;

  const SearchTournamentsPageAppBar({
    Key key,
    this.scrollController,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SearchTournamentsPageAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _SearchTournamentsPageAppBarState
    extends State<SearchTournamentsPageAppBar> {
  FocusNode _focusNode;
  TextEditingController _queryController;
  SortingController _sortingController;

  PublishSubject<String> _queryDebouncer;

  _SearchTournamentsPageAppBarState() {
    _queryDebouncer = PublishSubject<String>()
      ..stream
          .debounce(Duration(seconds: 1))
          .distinct()
          .listen((query) => _search());
  }

  @override
  Widget build(BuildContext context) =>
      StoreConnector<AppState, SearchTournamentsParametersState>(
        distinct: true,
        converter: (store) => store.state.searchState.searchParameters,
        builder: (context, state) => AppBar(
              iconTheme: Theme.of(context).iconTheme,
              backgroundColor: Theme.of(context).canvasColor,
              leading: _buildBackButton(context),
              title: _buildSearchField(context),
              actions: <Widget>[
                state.query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => _clear(),
                      )
                    : Container(),
                SortingButton(controller: _sortingController),
              ],
            ),
        onInit: _onInit,
        onDispose: _onDispose,
      );

  Widget _buildBackButton(BuildContext context) => IconButton(
        icon: const BackButtonIcon(),
        tooltip: MaterialLocalizations.of(context).backButtonTooltip,
        onPressed: () {
          _unFocus();
          Navigator.maybePop(context);
        },
      );

  Widget _buildSearchField(BuildContext context) => TextField(
        controller: _queryController,
        focusNode: _focusNode,
        autofocus: true,
        style: Theme.of(context).textTheme.title,
        textInputAction: TextInputAction.done,
        keyboardAppearance: Theme.of(context).brightness,
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: Strings.search,
        ),
      );

  void _onInit(Store<AppState> store) {
    _queryController = TextEditingController(
        text: store.state.searchState.searchParameters.query);
    _queryController.addListener(_onQueryChanged);

    _sortingController = SortingController(
        value: store.state.searchState.searchParameters.sorting);
    _sortingController.addListener(_onSortingChanged);
  }

  void _onDispose(Store<AppState> store) {
    _sortingController.removeListener(_onSortingChanged);
    _sortingController.dispose();

    _queryController.removeListener(_onQueryChanged);
    _queryController.dispose();

    store.dispatch(const VoidTournamentsSearchParameters());
  }

  @override
  void initState() {
    super.initState();

    _focusNode = FocusNode();

    if (widget.scrollController != null) {
      widget.scrollController.addListener(_onResultsScrolled);
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();

    if (widget.scrollController != null) {
      widget.scrollController.removeListener(_onResultsScrolled);
    }

    super.dispose();
  }

  @override
  void didUpdateWidget(SearchTournamentsPageAppBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.scrollController != null) {
      oldWidget.scrollController.removeListener(_onResultsScrolled);
    }
    if (widget.scrollController != null) {
      widget.scrollController.addListener(_onResultsScrolled);
    }
  }

  void _focus() => FocusScope.of(context).requestFocus(_focusNode);

  void _unFocus() => _focusNode.unfocus();

  void _forceFocus() => WidgetsBinding.instance.addPostFrameCallback((d) {
        _unFocus();
        WidgetsBinding.instance.addPostFrameCallback((d) => _focus());
      });

  void _clear() {
    _queryController.clear();

    _forceFocus();
  }

  void _onSortingChanged() => StoreProvider.of<AppState>(context)
      .dispatch(TournamentsSearchSortingChanged(_sortingController.value));

  void _onQueryChanged() {
    StoreProvider.of<AppState>(context)
        .dispatch(TournamentsSearchQueryChanged(_queryController.text));

    _queryDebouncer.sink.add(_queryController.text);
  }

  void _search() =>
      StoreProvider.of<AppState>(context).dispatch(const SearchTournaments());

  void _onResultsScrolled() {
    _unFocus();
  }
}
