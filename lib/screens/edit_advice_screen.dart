import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/advice_provider.dart';
import '../models/advice.dart';

class EditAdviceScreen extends StatelessWidget {
  final int index;
  EditAdviceScreen({super.key, required this.index});

  final TextEditingController _adviceController = TextEditingController();

  void _editAdvice(BuildContext context) {
    final adviceText = _adviceController.text;
    if (adviceText.isNotEmpty) {
      if (index == -1) {
        Provider.of<AdviceProvider>(context, listen: false).addAdvice(
          Advice(title: adviceText),
        );
      } else {
        Provider.of<AdviceProvider>(context, listen: false).editAdvice(
          index,
          Advice(title: adviceText),
        );
      }

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    String title = index == -1
        ? ''
        : Provider.of<AdviceProvider>(context).advices[index].title;
    _adviceController.text = title;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding:
            const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              maxLines: 5,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(10),
                border: OutlineInputBorder(),
              ),
              controller: _adviceController,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel',
                        style: TextStyle(fontSize: 16, color: Colors.black45))),
                TextButton(
                    onPressed: () => _editAdvice(context),
                    child: const Text('Save', style: TextStyle(fontSize: 16)))
              ],
            )
          ],
        ),
      ),
    );
  }
}
