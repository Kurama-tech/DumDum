import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class History extends ConsumerStatefulWidget {
  const History({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HistoryState();

}

class _HistoryState extends ConsumerState<History> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: const Text('History'),
    );
  }
  
}