import 'package:flutter/material.dart';
import 'package:journeyq/shared/components/bottom_naviagtion.dart';

class JoinTripPage extends StatefulWidget {
  const JoinTripPage({super.key});

  @override
  State<JoinTripPage> createState() => _JoinTripPageState();
}

class _JoinTripPageState extends State<JoinTripPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: const Center(
        child: Text(
          'Join Trip Page',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A1A),
          ),
        ),
      ),
    );
  }
}