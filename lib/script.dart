import 'package:equatable/equatable.dart';

class Script extends Equatable {
  final String symbol;
  final String exchange;
  final String company;
  final double ltp;

  const Script({
    required this.symbol,
    required this.exchange,
    required this.company,
    required this.ltp,
  });

  Script copyWith({double? ltp}) {
    return Script(
      symbol: symbol,
      exchange: exchange,
      company: company,
      ltp: ltp ?? this.ltp,
    );
  }

  @override
  List<Object?> get props => [symbol, exchange, company, ltp];
}
