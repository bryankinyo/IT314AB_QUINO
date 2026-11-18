import 'package:flutter/material.dart';
import '../core/db_connection.dart';

// CONNECTION SCREEN
// mo-connect sa database ug mo-show kung success or failed
class ConnectionScreen extends StatefulWidget {
  const ConnectionScreen({super.key});

  @override
  State<ConnectionScreen> createState() => _ConnectionScreenState();
}

class _ConnectionScreenState extends State<ConnectionScreen> {
  bool isConnecting = true; // nag-connect pa ba
  bool isConnected = false; // success ba
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    connect();
  }

  Future<void> connect() async {
    setState(() {
      isConnecting = true;
      errorMessage = '';
    });

    try {
      await DbConnection.connect();
      if (!mounted) return;

      setState(() {
        isConnecting = false;
        isConnected = true;
      });

      // hulat ug 1 second para makita ang success message
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/student-list');
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isConnecting = false;
        errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (isConnecting) {
      // loading state
      content = const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 15),
          Text('Connecting to database...'),
        ],
      );
    } else if (isConnected) {
      // success state
      content = const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle, color: Colors.green, size: 60),
          SizedBox(height: 15),
          Text('Connected to database!', style: TextStyle(fontSize: 18)),
        ],
      );
    } else {
      // failed state
      content = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error, color: Colors.red, size: 60),
          const SizedBox(height: 15),
          const Text('Connection failed', style: TextStyle(fontSize: 18)),
          const SizedBox(height: 10),
          Text(errorMessage, textAlign: TextAlign.center),
          const SizedBox(height: 15),
          ElevatedButton(onPressed: connect, child: const Text('Retry')),
        ],
      );
    }

    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,
      body: Center(
        child: Padding(padding: const EdgeInsets.all(20), child: content),
      ),
    );
  }
}
