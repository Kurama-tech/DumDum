import 'package:dumdum/screens/profilescreen.dart';
import 'package:dumdum/state/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../main.dart';
import '../providers/darkModeProvider.dart';
import '../providers/optinputprovider.dart';
import 'anouncments.dart';
import 'historyscreen.dart';

class MyHomePage extends StatefulHookConsumerWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  int _selectedIndex = 0;

  static const List<Widget> _screens = <Widget>[
    Profile(),
    Anouncements(),
    History(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    ref.read(otpinputProvider.notifier).stop();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        elevation: 8.0,
        //bottom: searchBar(context),
        centerTitle: true,
        title: Text(widget.title),
        leading: IconButton(
            onPressed: () {
              showSearch(context: context, delegate: CustomSearch());
            },
            icon: const Icon(Icons.search)),
        actions: const [DarkModeSwitcher(), Logout()],
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 4.0,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), label: 'Profile'),
          BottomNavigationBarItem(
              icon: Badge(label: Text('5'), child: Icon(Icons.campaign)),
              label: 'Anouncement'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      body: _screens.elementAt(_selectedIndex),
      floatingActionButton: _selectedIndex != 0
          ? Container()
          : FloatingActionButton(
              onPressed: () {},
              child: const Icon(Icons.add_a_photo),
            ),
    ); // This trailing comma makes auto-formatting nicer for build methods.
  }
}

class CustomSearch extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return ListView(
      children: const [
        ListTile(
          title: Text('hello'),
        )
      ],
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ListView(
      children: const [],
    );
  }
}

class DarkModeSwitcher extends HookConsumerWidget {
  const DarkModeSwitcher({super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    var darkMode = ref.watch(darkModeProvider);

    if (darkMode) {
      return IconButton(
          onPressed: () {
            ref.read(darkModeProvider.notifier).toggle();
          },
          icon: const Icon(Icons.sunny));
    }
    return IconButton(
        onPressed: () {
          ref.read(darkModeProvider.notifier).toggle();
        },
        icon: const Icon(Icons.dark_mode));
  }
}

class Logout extends HookConsumerWidget {
  const Logout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return IconButton(
        onPressed: () {
           ref.read(loginControllerProvider.notifier).signOut();
        },
        icon: const Icon(Icons.logout));
  }
}