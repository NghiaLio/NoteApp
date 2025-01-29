import 'package:flutter/material.dart';
import 'package:flutter_application_1/Config/configColor.dart';
import 'package:flutter_application_1/Models/Data/folder.dart';

import '../OfficeView/NoteOfFolder.dart';

class Itemfolder extends StatefulWidget {
  bool? isEdit;
  folder dataFolder;
  bool isChecked;
  Function(bool value)? checkBox;
  Itemfolder({super.key, this.isEdit, required this.dataFolder, this.checkBox,required this.isChecked });

  @override
  State<Itemfolder> createState() => _ItemfolderState();
}

class _ItemfolderState extends State<Itemfolder> {
  void tapToSeenFolder(folder dataFolder){
    Navigator.push(context, MaterialPageRoute(builder: (c)=> NoteOfFolder(dataFolder:dataFolder ,)));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          SizedBox(
            height: size.width*0.15,
            width: size.width*0.2,
            child: Transform.scale(
              scale: 1.2,
              child: Checkbox(
                activeColor: Colors.red,
                side: BorderSide(color:Theme.of(context).colorScheme.surface,width: 1.5),
                value: widget.isChecked,
                onChanged: (value)=> widget.checkBox!(value!),
                shape:const CircleBorder(),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            left: widget.isEdit! ? size.width*0.2 : 0,
            child: GestureDetector(
              onTap:()=> tapToSeenFolder(widget.dataFolder),
              child: Container(
                height: size.width*0.15,
                color: Theme.of(context).colorScheme.primary,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Icon(Icons.folder_open, size: 28,color: configColor.rgbaToColor(widget.dataFolder.color),),
                    const SizedBox(width: 30,),
                    Text(widget.dataFolder.name,style:const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w400
                    ))
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
