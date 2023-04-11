import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Anouncements extends ConsumerStatefulWidget {
  const Anouncements({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AnouncementsState();

}

class _AnouncementsState extends ConsumerState<Anouncements> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: const Text('Anouncements'),
    );
  }
  
}