import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/advice_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  void _save(BuildContext context) {
    FilePicker.platform.getDirectoryPath().then((path) {
      if (path != null) {
        Provider.of<AdviceProvider>(context, listen: false)
            .saveFile('$path/advices.txt');
      }
    });
  }

  void _load(BuildContext context) {
    FilePicker.platform.pickFiles().then((result) {
      if (result != null) {
        final path = result.files.single.path;
        Provider.of<AdviceProvider>(context, listen: false).loadFile(path!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    TimeOfDay time =
        Provider.of<AdviceProvider>(context).notifyTime;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
                onPressed: () {
                  showTimePicker(
                    context: context,
                    initialTime: time,
                    initialEntryMode: TimePickerEntryMode.inputOnly,
                    builder: (BuildContext context, Widget? child) {
                      return MediaQuery(
                        data: MediaQuery.of(context).copyWith(
                          alwaysUse24HourFormat: true,
                        ),
                        child: child!,
                      );
                    },
                  ).then((newTime) {
                    if (newTime != null) {
                      Provider.of<AdviceProvider>(context, listen: false)
                          .setNotifyTime(newTime);
                    }
                  });
                },
                child: Text('Notification on ${time.hour}:${time.minute}')),
            TextButton(
                onPressed: () => _save(context),
                child: const Wrap(
                  children: [Icon(Icons.upload), Text('Export')],
                )),
            TextButton(
                onPressed: () => _load(context),
                child: const Wrap(
                  children: [Icon(Icons.file_download_outlined), Text('Load')],
                )),
          ],
        ),
      ),
    );
  }
}
