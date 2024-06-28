import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/advice_provider.dart';
import '../widgets/advice_tile.dart';
import 'edit_advice_screen.dart';
import 'setting_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final length = Provider.of<AdviceProvider>(context).advices.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => showDialog<String>(
                context: context,
                builder: (BuildContext context) => const SettingScreen()),
          ),
        ],
      ),
      body: ListView.separated(
        itemCount: length,
        itemBuilder: (context, index) => AdviceTile(index: index),
        separatorBuilder: (context, index) => const Divider(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog<String>(
            context: context,
            builder: (BuildContext context) => EditAdviceScreen(index: -1)),
        child: const Icon(Icons.add),
      ),
    );
  }
}
