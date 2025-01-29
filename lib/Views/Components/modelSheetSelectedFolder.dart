import 'package:flutter/material.dart';
import 'package:flutter_application_1/Config/configColor.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Bloc/Events/ManageFolderCubit.dart';
import '../../Models/Data/folder.dart';
import '../../Theme/ColorFolder.dart';
import 'modelSheet.dart';

class modelSheetSelectedFolder extends StatefulWidget {

  const modelSheetSelectedFolder({super.key});

  @override
  State<modelSheetSelectedFolder> createState() => _modelSheetSelectedFolderState();
}

class _modelSheetSelectedFolderState extends State<modelSheetSelectedFolder> {

  TextEditingController controllerText = TextEditingController();
  void tapToSetFolder(folder dataFolder){
    Navigator.pop(context, dataFolder);
  }

  void tapToAddNewFolder(){
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        builder: (context){
          return Modelsheet(
            addFolder: (int selectedColorIndex)async{
              await context.read<manageFolderCubit>().createFolder(controllerText.text.trim(),configColor.colorToRGBA(listColor[selectedColorIndex]) );
              await context.read<manageFolderCubit>().getAllFolder();
              controllerText.clear();
              Navigator.pop(context);
            },
            controllerText: controllerText,
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    List<folder> listFolder = context.read<manageFolderCubit>().listFolder ?? [];
    return Padding(
        padding: EdgeInsets.only(
          left:20,
          right: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom +20
        ),
      child: SafeArea(
          child: Container(
            height:MediaQuery.of(context).size.height*0.5 ,
            width:MediaQuery.of(context).size.width ,
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.all(Radius.circular(25))
            ),
            child: listFolder.isEmpty ? otherSelected() : ListView.builder(
              itemCount: listFolder.length,
                itemBuilder: (context, index) => itemFolder(listFolder[index])
            ),
          )
      ),
    );
  }

  Widget itemFolder(folder dataFolder){
    return Column(
      children: [
        ListTile(
          onTap: ()=>tapToSetFolder(dataFolder),
          leading: Icon(Icons.folder_open, size:28 ,color: configColor.rgbaToColor(dataFolder.color),),
          title: Text(
            dataFolder.name,
            style:TextStyle(fontSize: 22,fontWeight: FontWeight.w500,color: Theme.of(context).colorScheme.surface),
          ),
        ),
        Divider(thickness: 1,endIndent: 20,indent: 20,color: Theme.of(context).colorScheme.surface.withOpacity(0.8),)
      ],
    );
  }

  Widget otherSelected(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Không có thư mục',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600,color: Theme.of(context).colorScheme.surface),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: ListTile(
            onTap:tapToAddNewFolder ,
            leading: const Icon(Icons.add, size: 30,color: Colors.green,),
            title: Text(
              'Tạo thư mục mới',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400,color: Theme.of(context).colorScheme.surface),
            ) ,
          ),
        )
      ],
    );
  }
}
