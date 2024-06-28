import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/advice_provider.dart';
import '../screens/edit_advice_screen.dart';

class AdviceTile extends StatelessWidget {
  final int index;

  const AdviceTile({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    String title = Provider.of<AdviceProvider>(context, listen: false)
        .advices[index]
        .title;

    return ListTile(
        title: Text(title),
        trailing: Wrap(spacing: 12, children: [
          IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => showDialog<String>(
                  context: context,
                  builder: (BuildContext context) =>
                      EditAdviceScreen(index: index))),
          IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                Provider.of<AdviceProvider>(context, listen: false)
                    .deleteAdvice(index);
              }),
        ]));
  }
}
