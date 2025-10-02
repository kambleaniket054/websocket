import 'package:equatable/equatable.dart';
import '../script.dart';


class WatchlistState extends Equatable {
  final int selectedTab;
  final List<String> watchlists;
  final Map<String, List<Script>> scripts;

  const WatchlistState({
    this.selectedTab = 0,
    this.watchlists = const ["Tech", "Banking", "Energy"],
    this.scripts = const {},
  });

  WatchlistState copyWith({
    int? selectedTab,
    Map<String, List<Script>>? scripts,
  }) {
    return WatchlistState(
      selectedTab: selectedTab ?? this.selectedTab,
      watchlists: watchlists,
      scripts: scripts ?? this.scripts,
    );
  }

  @override
  List<Object?> get props => [selectedTab, watchlists, scripts];
}
