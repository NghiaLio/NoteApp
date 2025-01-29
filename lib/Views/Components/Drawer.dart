import 'package:flutter/material.dart';
import 'package:flutter_application_1/Bloc/Events/ManageFolderCubit.dart';
import 'package:flutter_application_1/Bloc/States/NavigationState.dart';
import 'package:flutter_application_1/Config/configColor.dart';
import 'package:flutter_application_1/Models/Data/folder.dart';
import 'package:flutter_application_1/Views/OfficeView/ManageFolder.dart';
import 'package:flutter_application_1/Views/OfficeView/NoteOfFolder.dart';
import 'package:flutter_application_1/Views/OfficeView/Setting.dart';
import '../../Bloc/Events/Navigation.dart';
import '../../Bloc/Events/openDrawer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeDrawer extends StatefulWidget {
  int? currentIndexPage;
  HomeDrawer({super.key, this.currentIndexPage});

  @override
  State<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  late bool isOpenFolder;
  late bool backGroundItemFunction;
  
  void tapToManage(){
    Navigator.push(context, MaterialPageRoute(builder: (c)=>Managefolder()));
  }

  void openMoreFolder() {
    context.read<NavigationCubit>().nextScreen(4);
    setState(() {
      isOpenFolder = !isOpenFolder;
    });
  }

  void tapToNoteOfFolder(folder dataFolder){
    Navigator.push(context, MaterialPageRoute(builder: (c)=> NoteOfFolder(dataFolder:dataFolder ,)));
  }

  @override
  void initState() {
    if(widget.currentIndexPage! == 4){
      isOpenFolder = true;
    }else{
      isOpenFolder = false;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<folder> listFolder = context.read<manageFolderCubit>().listFolder ?? [];
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.95,
      width: size.width * 0.8,
      decoration:  BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(15),
            bottomRight: Radius.circular(15),
          )),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            //Icon setting
            Padding(
              padding: const EdgeInsets.only(right: 20, top: 20),
              child: IconButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (c)=>settingScreen()));
                  },
                  icon: Icon(
                    Icons.settings,
                    size: 32,
                    color: Theme.of(context).colorScheme.onSurface,
                  )),
            ),
            //list function
            const SizedBox(
              height: 10,
            ),
            ItemFunction(Icons.description_outlined, "Tất cả ghi chú", () {
              context.read<NavigationCubit>().nextScreen(0);
              context.read<Opendrawer>().getClose();
            }, context.read<NavigationCubit>().backGroundItemFunction[0],Theme.of(context).colorScheme.onSurface),
            ItemFunction(Icons.lock, "Ghi chú bị khóa", () {
              context.read<NavigationCubit>().nextScreen(1);
              context.read<Opendrawer>().getClose();
            }, context.read<NavigationCubit>().backGroundItemFunction[1],Theme.of(context).colorScheme.onSurface),
            ItemFunction(Icons.star, "Mục yêu thích", () {
              context.read<NavigationCubit>().nextScreen(2);
              context.read<Opendrawer>().getClose();
            }, context.read<NavigationCubit>().backGroundItemFunction[2],Theme.of(context).colorScheme.onSurface),
            ItemFunction(Icons.delete, "Thùng rác", () {
              context.read<NavigationCubit>().nextScreen(3);
              context.read<Opendrawer>().getClose();
            }, context.read<NavigationCubit>().backGroundItemFunction[3],Theme.of(context).colorScheme.onSurface),

            Divider(
              thickness: 0.5,
              color: Theme.of(context).colorScheme.onSurface,
              indent: 20,
              endIndent: 20,
            ),
            //folder
            ItemFunction(
                isOpenFolder! ? Icons.folder_open : Icons.folder,
                "Thư mục",
                openMoreFolder,
                context.read<NavigationCubit>().backGroundItemFunction[4],
                Theme.of(context).colorScheme.onSurface
            ),

            //more folder
            isOpenFolder!
                ? Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Column(
                      children: [
                        for(int i=0; i< listFolder.length; i++)
                          ItemFunction(Icons.folder_open, listFolder[i].name, ()=>tapToNoteOfFolder(listFolder[i]), false, configColor.rgbaToColor(listFolder[i].color))
                      ],
                    ),
                  )
                : Container(),
            const SizedBox(
              height: 20,
            ),
            //Button
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: tapToManage,
                  child: Container(
                    alignment: Alignment.center,
                    height: size.height * 0.05,
                    width: size.width * 0.6,
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(50))),
                    child: Text(
                      'Quản lý thư mục',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600,color:Theme.of(context).colorScheme.surface),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget ItemFunction(
      IconData icon, String title, Function()? onTap, bool isBackground,Color colorIcon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Container(
        decoration: BoxDecoration(
            color: isBackground ? Theme.of(context).colorScheme.onSurface.withOpacity(0.4) : Theme.of(context).colorScheme.primary,
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        child: ListTile(
          onTap: onTap,
          leading: Icon(
            icon,
            size: 28,
            color: colorIcon,
          ),
          title: Text(
            title,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400, color:Theme.of(context).colorScheme.surface ),
          ),
        ),
      ),
    );
  }
}
