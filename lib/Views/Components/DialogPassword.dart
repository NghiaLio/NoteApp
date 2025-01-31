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
      backgroundColor: Theme.of(context).colorScheme.background,
      title: Text('Unlock',style: TextStyle(color: Theme.of(context).colorScheme.surface,fontSize: 18),),
      content: TextField(
        style: TextStyle(color: Theme.of(context).colorScheme.surface, fontSize: 16),
        decoration: const InputDecoration(
            hintText: 'Nhap mk', border: OutlineInputBorder()),
        controller: passController,
      ),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.8)
          ),
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
