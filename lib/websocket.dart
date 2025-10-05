import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
class WebSocketService {
  late final WebSocketChannel _channel;
  late final StreamController<Map<String, dynamic>> _streamController;
  Timer? _fakeMarketTimer;

  Stream<Map<String, dynamic>> get stream => _streamController.stream;

  WebSocketService() {
    _streamController = StreamController.broadcast();
    _connect();
  }

  void _connect() {
    _channel = WebSocketChannel.connect(
      Uri.parse("wss://echo.websocket.org"),
    );

    _channel.stream.listen((message) {
      // When echo server replies, decode it and emit to listeners
      try {
        final decoded = jsonDecode(message);
        if (decoded is Map<String, dynamic>) {
          _streamController.add(decoded);
        }
      } catch (_) {
        // ignore invalid json
      }
    });

    // Simulate sending periodic updates
    _fakeMarketTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      final fakeUpdate = {
        "symbol": ["INFY", "TCS", "HDFCBANK", "ICICIBANK", "RELIANCE"]
            .elementAt(DateTime.now().second % 5),
        "ltp": 1000 + (DateTime.now().millisecond % 3000) / 10,
      };
      _channel.sink.add(jsonEncode(fakeUpdate)); // send to echo server
    });
  }

  sendMessage(dynamic message) {
    _channel.sink.add(message);
  }

  void dispose() {
    _fakeMarketTimer?.cancel();
    _channel.sink.close();
    _streamController.close();
  }
}