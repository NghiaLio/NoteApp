import 'package:flutter/material.dart';
import 'package:flutter_application_1/Config/configColor.dart';

import '../../Models/Data/folder.dart';
import 'modelSheetSelectedFolder.dart';

class MyTopSheet extends StatefulWidget {
  String titleText;
  bool isFavorite;
  folder? dataFolder;
  MyTopSheet({super.key, required this.titleText, required this.isFavorite, this.dataFolder});

  @override
  State<MyTopSheet> createState() => _MyTopSheetState();
}

class _MyTopSheetState extends State<MyTopSheet> {
  TextEditingController titleController = TextEditingController();
  // folder? dataFolder;

  @override
  void initState() {
    setState(() {
      titleController.text = widget.titleText;
    });
    super.initState();
  }

  void tapToshowSelectedFolder() async{
    final folder folderSelected = await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context)=>modelSheetSelectedFolder()
    );
    setState(() {
      widget.dataFolder = folderSelected;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height*0.25,
      width: size.width,
      color: Theme.of(context).colorScheme.primary,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: (){
                      Navigator.pop(context,
                          {
                            'textTitle' : titleController.text,
                            'isFavorite': widget.isFavorite,
                            'folder': widget.dataFolder
                          }
                          // [titleController.text, widget.isFavorite]
                      );
                    },
                    icon: Icon(Icons.arrow_upward, size: 24,color: Theme.of(context).colorScheme.surface)
                ),
                IconButton(
                    onPressed: (){
                      setState(() {
                        widget.isFavorite = !widget.isFavorite;
                      });
                    },
                    icon: Icon( widget.isFavorite ? Icons.star_purple500_outlined :  Icons.star_outline_sharp, size: 26,color:widget.isFavorite ? Colors.yellow : null ,)
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: TextField(
              controller: titleController,
              decoration: InputDecoration(
                  hintText: 'Tiêu đề',
                  hintStyle:TextStyle(fontSize: 26, fontWeight: FontWeight.w500, color: Theme.of(context).colorScheme.onSurface) ,
                  border: InputBorder.none
              ),
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500,color: Theme.of(context).colorScheme.surface),
            ),
          ),
          // const SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: GestureDetector(
              onTap: tapToshowSelectedFolder,
              child: Row(
                children: [
                  Icon(Icons.folder_open, size: 24,color:configColor.rgbaToColor(widget.dataFolder!.color),),
                  const SizedBox(width: 10,),
                  Text(
                    widget.dataFolder!.name,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Theme.of(context).colorScheme.onSurface),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}