import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitledwebsocket/Bloc/watchlist_event.dart';
import 'package:untitledwebsocket/Bloc/watchlist_state.dart';
import 'package:untitledwebsocket/script.dart';

import '../websocket.dart';


class WatchlistBloc extends Bloc<WatchlistEvent, WatchlistState> {
  Timer? _timer;
  final WebSocketService _webSocketService;
  StreamSubscription? _socketSubscription;

  WatchlistBloc(this._webSocketService) : super(const WatchlistState()) {
    // Initialize with some fake scripts
    final Map<String, List<Script>> initialScripts = {
      "Tech": [
        const Script(symbol: "INFY", exchange: "NSE", company: "Infosys", ltp: 1550.0),
        const Script(symbol: "TCS", exchange: "BSE", company: "Tata Consultancy", ltp: 3800.0),
      ],
      "Banking": [
        const Script(symbol: "HDFCBANK", exchange: "NSE", company: "HDFC Bank", ltp: 1520.0),
        const Script(symbol: "ICICIBANK", exchange: "BSE", company: "ICICI Bank", ltp: 980.0),
      ],
      "Energy": [
        const Script(symbol: "RELIANCE", exchange: "NSE", company: "Reliance Industries", ltp: 2460.0),
      ],
    };

    on<LoadWatchlist>(_onLoadWatchlist);
    on<UpdateLtp>(_onUpdateLtp);

    emit(state.copyWith(scripts: initialScripts));

    _timer = Timer.periodic(const Duration(seconds: 2), (_) {
      final random = Random();
      for (var wl in state.scripts.keys) {
        for (var s in state.scripts[wl]!) {
          final newLtp = s.ltp + (random.nextBool() ? 5 : -5);
          final fakeUpdate = {
            "symbol":s.symbol,
            "ltp": newLtp,
          };
          _webSocketService.sendMessage(jsonEncode(fakeUpdate));

        }
      }
    });

    _socketSubscription = _webSocketService.stream.listen((data) {
      final symbol = data["symbol"];
      final ltp = (data["ltp"] as num).toDouble();
      add(UpdateLtp(symbol, ltp));
    });
  }

  void _onLoadWatchlist(LoadWatchlist event, Emitter<WatchlistState> emit) {
    emit(state.copyWith(selectedTab: event.tabIndex));
  }

  void _onUpdateLtp(UpdateLtp event, Emitter<WatchlistState> emit) {
    final updatedScripts = Map<String, List<Script>>.from(state.scripts);

    updatedScripts.forEach((wl, list) {
      updatedScripts[wl] = list.map((script) {
        if (script.symbol == event.symbol) {
          return script.copyWith(ltp: event.ltp);
        }
        return script;
      }).toList();
    });

    emit(state.copyWith(scripts: updatedScripts));
  }

  @override
  Future<void> close() {
    _socketSubscription?.cancel();
    _webSocketService.dispose();
    _timer?.cancel();
    return super.close();
  }
}
