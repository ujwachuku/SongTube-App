// Dart
import 'dart:io';

// Flutter
import 'package:flutter/material.dart';

// Internal
import 'package:songtube/provider/managerProvider.dart';

// Packages
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

// UI
import 'package:songtube/screens/moreScreen/widgets/settings/columnTile.dart';
import 'package:songtube/ui/internal/snackbar.dart';

class BackupSettings extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  BackupSettings({
    @required this.scaffoldKey
  });
  @override
  Widget build(BuildContext context) {
    AppSnack snackbar = new AppSnack(scaffoldKey: scaffoldKey, context: context, addPadding: false);
    ManagerProvider manager = Provider.of<ManagerProvider>(context);
    return SettingsColumnTile(
      title: "Backup",
      icon: EvaIcons.saveOutline,
      children: <Widget>[
        ListTile(
          title: Text(
            "Backup",
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyText1.color,
              fontWeight: FontWeight.w500
            ),
          ),
          subtitle: Text("Backup your media library",
            style: TextStyle(fontSize: 12)
          ),
          trailing: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Theme.of(context).accentColor
            ),
            child: IconButton(
              icon: Icon(EvaIcons.cloudDownloadOutline, color: Colors.white),
              onPressed: () async {
                Directory documentsDirectory = await getApplicationDocumentsDirectory();
                String backupPath = await ExtStorage.getExternalStorageDirectory() + "/SongTube/Backup/";
                if (!await Directory(backupPath).exists()) await Directory(backupPath).create();
                String path = join(documentsDirectory.path, 'MediaItems.db');
                if (!await File(path).exists()) {
                  snackbar.showSnackBar(
                    icon: Icons.warning,
                    title: "Your Library is Empty",
                    duration: Duration(seconds: 2)
                  );
                  return;
                }
                await File(path).copy(backupPath + 'MediaItems.db');
                snackbar.showSnackBar(
                  icon: Icons.backup,
                  title: "Backup Completed",
                  duration: Duration(seconds: 2)
                );
              }
            )
          )
        ),
        ListTile(
          title: Text(
            "Restore",
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyText1.color,
              fontWeight: FontWeight.w500
            ),
          ),
          subtitle: Text("Restore your media library",
            style: TextStyle(fontSize: 12)
          ),
          trailing: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Theme.of(context).accentColor
            ),
            child: IconButton(
              icon: Icon(EvaIcons.refreshOutline, color: Colors.white),
              onPressed: () async {
                Directory documentsDirectory = await getApplicationDocumentsDirectory();
                String backupPath = await ExtStorage.getExternalStorageDirectory() + "/SongTube/Backup/";
                String path = join(documentsDirectory.path, 'MediaItems.db');
                if (!await File(backupPath + 'MediaItems.db').exists()) {
                  snackbar.showSnackBar(
                    icon: Icons.warning,
                    title: "You have no Backup",
                    duration: Duration(seconds: 2)
                  );
                  return;
                }
                await File(backupPath + 'MediaItems.db').copy(path);
                snackbar.showSnackBar(
                    icon: Icons.restore,
                    title: "Restore Completed",
                    duration: Duration(seconds: 2)
                  );
                manager.getDatabase();
              }
            )
          )
        ),
      ],
    );
  }
}