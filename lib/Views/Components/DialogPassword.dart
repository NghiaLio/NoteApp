import 'package:flutter/material.dart';

import '../../Models/Data/note.dart';
import '../OfficeView/NoteScreen.dart';

class dialogPass extends StatelessWidget {

  final TextEditingController passController;
  final note noteData;
  const dialogPass({super.key, required this.passController,required this.noteData});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Unlock',style: TextStyle(color: Theme.of(context).colorScheme.surface),),
      content: TextField(
        style: TextStyle(color: Theme.of(context).colorScheme.surface),
        decoration: const InputDecoration(
            hintText: 'Nhap mk', border: OutlineInputBorder()),
        controller: passController,
      ),
      actions: [
        ElevatedButton(
            onPressed: () {
              if (passController.text.trim() == noteData.password) {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (c) => Notescreen(
                          isCreateScreen: false,
                          noteData: noteData,
                        )));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('pass not true', style: TextStyle(color: Theme.of(context).colorScheme.surface),)));
                passController.clear();
              }
            },
            child: Text('unLock', style: TextStyle(color: Theme.of(context).colorScheme.surface),))
      ],
    );
  }
}
