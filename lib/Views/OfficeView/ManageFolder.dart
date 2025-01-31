import 'package:flutter/material.dart';
import 'package:flutter_application_1/Bloc/Events/ManageFolderCubit.dart';
import 'package:flutter_application_1/Bloc/States/ManageFolderState.dart';
import 'package:flutter_application_1/Models/Data/folder.dart';
import 'package:flutter_application_1/Views/Components/ItemFolder.dart';
import 'package:flutter_application_1/Views/Components/modelSheet.dart';
import 'package:flutter_application_1/Views/Components/modelsheetName.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Config/configColor.dart';
import '../../Theme/ColorFolder.dart';
import '../Components/modelSheetColor.dart';

class Managefolder extends StatefulWidget {
  const Managefolder({super.key});

  @override
  State<Managefolder> createState() => _ManagefolderState();
}

class _ManagefolderState extends State<Managefolder> {
  bool isEdit = false;
  bool isCheckAll = false;
  late List<bool> checkEdit;

  TextEditingController controllerText = TextEditingController();
  //edit state
  void edit(){
    setState(() {
      isEdit = true;
    });
  }

  // show modalbottomSheet
  void tapToAddNew(){
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        builder: (context){
          return Modelsheet(
            addFolder: (int selectedColorIndex)async{
              await context.read<manageFolderCubit>().createFolder(controllerText.text.trim(),configColor.colorToRGBA(listColor[selectedColorIndex]) );
              await context.read<manageFolderCubit>().getAllFolder();
              await setCheckEdit();
              controllerText.clear();
              Navigator.pop(context);
            },
            controllerText: controllerText,
          );
        }
    );
  }

  //show modelSheetColor
  void tapToUpdateColor(List<folder> dataFolder){
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context)=>modelSheetColor(
        updateColor: (int indexColor)async{
          print(indexColor);
          for(int i=0; i< checkEdit.length; i++){
            if(checkEdit[i] == true){
              folder data = folder(id: dataFolder[i].id, name: dataFolder[i].name, color: configColor.colorToRGBA(listColor[indexColor]));
              await context.read<manageFolderCubit>().updateFolder(data);
            }
          }
          await context.read<manageFolderCubit>().getAllFolder();
          if(isCheckAll){
            setState(() {
              isCheckAll = false;
            });
          }
          setFalseCheckEdit();
          Navigator.pop(context);
        }
      ),
    );
    

  }

  //show modelSheetName
  void tapToUpdateName(List<folder> dataFolder){
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) =>modelSheetName(
          updateName: () async{
            for(int i=0; i< checkEdit.length; i++){
              if(checkEdit[i] == true){
                folder data = folder(id: dataFolder[i].id, name:controllerText.text.trim(), color: dataFolder[i].color);
                await context.read<manageFolderCubit>().updateFolder(data);
              }
            }
            await context.read<manageFolderCubit>().getAllFolder();
            setFalseCheckEdit();
            Navigator.pop(context);
          },
          textController: controllerText,)
    );
  }

  //checked box
  void checkedBox(value, index){
    setState(() {
      checkEdit[index] = value;
      if(checkEdit.contains(false) == false){
        isCheckAll = true;
      }else{
        isCheckAll = false;
      }
    });
  }

  void checkAll(bool? value){
    setState(() {
      isCheckAll = value!;
      checkEdit = checkEdit.map((e)=> value).toList();
    });
  }

  //deleteFolder
  void deleteFolder(List<folder> dataFolder) async{
    for(int i=0; i< checkEdit.length; i++){
      if(checkEdit[i] == true){
        await context.read<manageFolderCubit>().deleteFolder(dataFolder[i].id!);
      }
    }
    await context.read<manageFolderCubit>().getAllFolder();
    setFalseCheckEdit();
  }

  void deleteAllFolder() async{
    await context.read<manageFolderCubit>().deleteAllFolder();
    await context.read<manageFolderCubit>().getAllFolder();
    setState(() {
      isCheckAll = false;
    });
    setFalseCheckEdit();
  }

  Future<void> setCheckEdit() async{
    final listFolder = context.read<manageFolderCubit>().listFolder ?? [];
    setState(() {
      checkEdit = listFolder.map((e)=> false).toList();
    });
  }

  void setFalseCheckEdit(){
    setState(() {
      checkEdit = checkEdit.map((e)=> false).toList();
    });
  }

  @override
  void initState() {
    setCheckEdit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        if(isEdit){
          setState(() {
            isEdit = false;
            checkEdit = checkEdit.map((e)=> false).toList();
          });
          return false;
        }else{
          return true;
        }

      },
      child: BlocBuilder<manageFolderCubit,manageFolderState>(
          builder: (context, state){
            if(state is loadedManage){
              List<folder> listFolder = state.listFolder ?? [];
              return Scaffold(
                backgroundColor: Theme.of(context).colorScheme.background,
                appBar: AppBar(
                  backgroundColor:Theme.of(context).colorScheme.background,
                  leading:!isEdit
                      ? IconButton(onPressed: (){
                    Navigator.pop(context);
                  }, icon: Icon(Icons.arrow_back_ios_new, size: 30,color: Theme.of(context).colorScheme.surface,))
                      : Transform.scale(
                    scale: 1.2,
                    child: Checkbox(
                      side: BorderSide(color: Theme.of(context).colorScheme.surface, width: 1.5 ),
                      activeColor: Colors.red,
                      value: isCheckAll,
                      onChanged: checkAll,
                      shape:
                      const CircleBorder(),
                    ),
                  ),
                  title:isEdit ?  Text(
                    'Tất cả',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight:
                        FontWeight.w500,color: Theme.of(context).colorScheme.surface,),
                  ):  Text(
                    'Quản lý thư mục',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700,color: Theme.of(context).colorScheme.surface),
                  ),
                  actions: [
                    isEdit ? Container() :Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: GestureDetector(
                        onTap: edit,
                        child: Text(
                          'Sửa',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700,color: Theme.of(context).colorScheme.surface),
                        ),
                      ),
                    )
                  ],
                ),
                body: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    // main
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                          itemCount: listFolder.length + 1,
                          itemBuilder: (context, index){
                            if(index <listFolder.length){
                              return Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.primary,
                                    borderRadius: index == 0 ? const BorderRadius.only(topLeft: Radius.circular(15), topRight:Radius.circular(15), ) : null
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Itemfolder(isEdit: isEdit,dataFolder: listFolder[index],isChecked: checkEdit[index],checkBox:(value)=>checkedBox(value, index) ,),
                                    const Divider(thickness: 1, endIndent: 20,indent: 20,height: 5,)
                                  ],
                                ),
                              );
                            }else{
                              return Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius:listFolder.isEmpty ? const BorderRadius.all(Radius.circular(20)) :
                                  const BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight:Radius.circular(20) ),
                                ),
                                child: ListTile(
                                  onTap:isEdit ? null : tapToAddNew,
                                  leading:  Icon(Icons.add, size: 35,color:isEdit? Colors.green.withOpacity(0.5) : Colors.green,),
                                  title:  Text('Tạo thư mục',style:TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400,
                                    color: isEdit ? Theme.of(context).colorScheme.surface.withOpacity(0.5) : Theme.of(context).colorScheme.surface
                                  )),
                                ),
                              );
                            }
                          }
                      ),
                    ),

                    //bottomBar
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 200),
                        bottom: checkEdit.contains(true) ? 0 : -MediaQuery.of(context).size.height*0.1,
                        child: bottomBar(listFolder)
                    )
                  ],
                ),
              );
            }else{
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          }
      ),
    );
  }

  Widget bottomBar(List<folder> listFolder){
    return Container(
      height: MediaQuery.of(context).size.height*0.1-15,
      width:MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary
      ),
      padding:const EdgeInsets.all(5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
           Flexible(flex: 1,
              child: Center(child: itemBottomBar('Màu thư mục', Icons.color_lens_outlined,()=> tapToUpdateColor(listFolder)))),
          isCheckAll && listFolder.length > 1 ? Container() : Flexible(flex: 1,
              child: Center(child: itemBottomBar('Đổi tên', Icons.edit,()=> tapToUpdateName(listFolder)))),
          Flexible(flex: 1,
              child: Center(child: itemBottomBar(isCheckAll ? 'Xóa tất cả' : 'Xóa', Icons.delete_outline_outlined,()=> isCheckAll ? deleteAllFolder() : deleteFolder(listFolder))))
        ],
      ),
    );
  }

  Widget itemBottomBar(String text, IconData icon, Function()? onTap){
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, size: 26,color: Theme.of(context).colorScheme.surface,),
          Text(
            text,
            style:  TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Theme.of(context).colorScheme.surface,overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }
}
