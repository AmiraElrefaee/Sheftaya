import 'dart:developer';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../constants/shared_pref_helper.dart';
import '../constants/shared_pref_keys.dart';
import '../networking/api_constants.dart';

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  IO.Socket? _socket;
  bool _isConnecting = false;
  String? _currentJobId;

  static const String _baseUrl = "https://sheftaya-production.up.railway.app";

  Future<void> connect() async {
    if (_socket?.connected == true || _isConnecting) return;
    _isConnecting = true;

    try {
      final token = await SharedPrefHelper.getSecuredString(
        SharedPrefKeys.userToken,
      );

      if (token.isEmpty) {
        log('⚠️ No token found');
        return;
      }

      log('🔑 Connecting with token: $token');

      _socket?.dispose();
      _socket = null;

      // _socket = IO.io(
      //   _baseUrl,
      //   IO.OptionBuilder()
      //       .setTransports(['polling', 'websocket'])
      //       .setAuth({'token': token})
      //       .setQuery({'token': token})
      //       .enableReconnection()
      //       .setReconnectionAttempts(999999)
      //       .setReconnectionDelay(300)
      //       .setReconnectionDelayMax(1500)
      //       .disableAutoConnect()
      //       .build(),
      // );
      _socket = IO.io(
        _baseUrl,
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .setAuth({'token': token})
        // ❌ شيلي السطر ده
        // .setQuery({'token': token})
            .enableReconnection()
            .setReconnectionAttempts(999999)
            .setReconnectionDelay(300)
            .setReconnectionDelayMax(1500)
            .disableAutoConnect()
            .build(),
      );

      _registerListeners();
      _socket!.connect();

      log('🔌 Socket connecting...');
    } catch (e) {
      log('❌ Socket connect error: $e');
    } finally {
      _isConnecting = false;
    }
  }

  void _registerListeners() {
    _socket!
      ..onConnect((_) {
        log('✅ Socket Connected');
        // Rejoin room after reconnect
        if (_currentJobId != null) {
          _socket?.emit('join_job', _currentJobId);
          log('🏠 Re-joined job room: $_currentJobId');
        }
      })
      ..onDisconnect((reason) {
        log('❌ Socket Disconnected: $reason');
      })
      ..onConnectError((error) {
        log('🚨 Socket Connect Error: $error');
      })
      ..onReconnect((_) {
        log('🔄 Socket Reconnected');
        if (_currentJobId != null) {
          _socket?.emit('join_job', _currentJobId);
        }
      });
  }

  void joinJobRoom(String jobId) {
    _currentJobId = jobId;
    _socket?.emit('join_job', jobId);
    log('📡 Joined job room: $jobId');
  }

  void leaveJobRoom(String jobId) {
    _socket?.emit('leave_job', jobId);
    _currentJobId = null;
  }

  // Worker Actions
  void workerOnTheWay(String appId, String workerId) {
    _socket?.emit('worker_on_the_way', {
      'appId': appId,
      'workerId': workerId,
      'status': 'on_the_way',
      'time': DateTime.now().toIso8601String(),
    });
  }

  void workerArrived(String appId, String workerId) {

    _socket?.emit('worker_arrived', {
      'appId': appId,
      'workerId': workerId,
      'status': 'arrived',
      'time': DateTime.now().toIso8601String(),
    });
  }

  // Employer Actions
  void approveArrival(String appId) {
    _socket?.emit('arrival_approved', {
      'appId': appId,
      'status': 'arrived_approved',
      'time': DateTime.now().toIso8601String(),
    });
  }

  void startShift(String appId) {
    _socket?.emit('shift_started', {
      'appId': appId,
      'status': 'in_progress',
      'time': DateTime.now().toIso8601String(),
    });
  }

  void endShift(String appId) {
    _socket?.emit('shift_completed', {
      'appId': appId,
      'status': 'completed',
      'time': DateTime.now().toIso8601String(),
    });
  }

  void on(String event, Function(dynamic) handler) {
    _socket?.on(event, handler);
  }

  void off(String event) {
    _socket?.off(event);
  }

  void disconnect() {
    _socket?.dispose();
    _socket = null;
  }
}