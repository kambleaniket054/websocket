import 'package:equatable/equatable.dart';

abstract class WatchlistEvent extends Equatable {
  const WatchlistEvent();

  @override
  List<Object?> get props => [];
}

class LoadWatchlist extends WatchlistEvent {
  final int tabIndex;
  const LoadWatchlist(this.tabIndex);

  @override
  List<Object?> get props => [tabIndex];
}

class UpdateLtp extends WatchlistEvent {
  final String symbol;
  final double ltp;
  const UpdateLtp(this.symbol, this.ltp);

  @override
  List<Object?> get props => [symbol, ltp];
}
