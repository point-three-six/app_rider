import 'package:app_rider/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:app_rider/ui/widgets/full_map.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:provider/provider.dart';
import 'package:app_rider/models/user.dart';
import 'package:app_rider/ui/widgets/main_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int counter = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: const MainDrawer(),
      body: Column(
        //children: [FullMap()],
        children: [Text('*map widget here*')],
      ),
    );
  }
}
