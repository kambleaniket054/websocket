import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitledwebsocket/script.dart';

import 'Bloc/watchlist_event.dart';
import 'Bloc/watchlist_state.dart';
import 'Bloc/watchlistbloc.dart';


class WatchlistPage extends StatelessWidget {
  const WatchlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WatchlistBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Watchlist"),
          centerTitle: true,
        ),
        body: BlocBuilder<WatchlistBloc, WatchlistState>(
          builder: (context, state) {
            final currentWatchlist = state.watchlists[state.selectedTab];
            final currentScripts = state.scripts[currentWatchlist] ?? [];

            return Column(
              children: [
                // Horizontal Tabs
                SizedBox(
                  height: 50,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    scrollDirection: Axis.horizontal,
                    itemCount: state.watchlists.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      final isSelected = state.selectedTab == index;
                      return ChoiceChip(
                        label: Text(state.watchlists[index]),
                        selected: isSelected,
                        onSelected: (_) {
                          context.read<WatchlistBloc>().add(LoadWatchlist(index));
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      );
                    },
                  ),
                ),

                // Script list
                Expanded(
                  child: ListView.builder(
                    itemCount: currentScripts.length,
                    itemBuilder: (context, index) {
                      final Script script = currentScripts[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          title: Text("${script.symbol} (${script.exchange})"),
                          subtitle: Text(script.company),
                          trailing: Text(
                            "₹${script.ltp.toStringAsFixed(2)}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: script.ltp % 2 == 0 ? Colors.green : Colors.red,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
