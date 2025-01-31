import 'package:flutter/material.dart';
import '../../Bloc/States/HomeState.dart';
import '../../Config/configColor.dart';
import '../../Models/Data/folder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Bloc/Events/HomeEvent.dart';
import '../../Models/Data/note.dart';
import '../Components/DialogPassword.dart';
import '../Components/modelSheetSelectedFolder.dart';
import 'NoteScreen.dart';

class NoteOfFolder extends StatefulWidget {
  Function()? tapMenu;
  final folder dataFolder;
  NoteOfFolder({super.key, this.tapMenu,required this.dataFolder});

  @override
  State<NoteOfFolder> createState() => _CyclebinState();
}

class _CyclebinState extends State<NoteOfFolder> {
  bool isEdit = false;
  bool isCheckAll = false;
  bool isLock = false;
  bool isFavorite = false;
  final ScrollController _scrollController = ScrollController();
  final passController = TextEditingController();

   List<bool>? checkEdit;
  
  void tapToEdit(List<note> listnote){
    if(listnote.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Không có ghi chú để chỉnh sửa",style: TextStyle(fontSize: 18),))
      );
    }else{
      setState(() {
        isEdit = true;
      });
    }
  }

  void checkLock(List<note> listNote){
    final List check =[];
    //lấy ra các item đã tích check
    for(int i=0; i< checkEdit!.length; i++){
      if(checkEdit![i] ==  true){
        check.add(listNote[i]);
      }
    }
    //kiểm tra số lượng item  khóa
    int numLock = 0;
    int numFavorite = 0;
    for (var e in check) {
          if(e.isLock == true){
            numLock++;
          }
          if(e.isFavorite == true){
            numFavorite++;
          }
        }
    //nếu numLock bằng so item đã check
    if(numLock == check.length){
      setState(() {
        isLock = false;
      });
    }else{
      setState(() {
        isLock = true;
      });
    }
    //nếu numFavorite = số item đã check
    if(numFavorite == check.length){
      setState(() {
        isFavorite = false;
      });
    }else{
      setState(() {
        isFavorite = true;
      });
    }
  }


  //checked box
  void EditTap(bool? value, int index, List<note> listNote) {
    setState(() {
      checkEdit![index] = value!;
      if (!checkEdit!.contains(false)) {
        isCheckAll = true;
      } else {
        isCheckAll = false;
      }
    });

    checkLock(listNote);
  }

  void checkAll(bool? value, List<note> listNote) {
    setState(() {
      isCheckAll = value!;
      checkEdit = checkEdit!.map((e) => value).toList();
    });
    checkLock(listNote);
  }

  void setFalseCheckEdit(){
    setState(() {
      checkEdit = checkEdit!.map((e)=> false).toList();
    });
  }
  //deleteNote
  void deleteNote(List<note> list_note) async {
    for (int i = 0; i < checkEdit!.length; i++) {
      if (checkEdit![i] == true) {
        context.read<homeEvent>().updateDelete(list_note[i]);
      }
    }
    // ẩn bottom
    setFalseCheckEdit();
  }

  //lock
  void lockNote(List<note> list_note) {
    for (int i = 0; i < checkEdit!.length; i++) {
      if (checkEdit![i] == true) {
        context.read<homeEvent>().updateLock(list_note[i]);
      }
    }
    checkEdit = checkEdit!.map((e) => false).toList();
  }
  //addFavorite
  void addFavorite(List<note> list_note) {
    for (int i = 0; i < checkEdit!.length; i++) {
      if (checkEdit![i] == true) {
        if(list_note[i].isFavorite){
          context.read<homeEvent>().updateFavorite(list_note[i], false);
        }else{
          context.read<homeEvent>().updateFavorite(list_note[i], true);
        }
      }
    }
    checkEdit = checkEdit!.map((e) => false).toList();
  }

  //seen
  void tapToSeen(note noteData) async{
    if (noteData.isLock) {
      showDialog(
          context: context,
          builder: (context) => dialogPass(passController:passController, noteData: noteData ));
    } else {
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (c) => Notescreen(
                isCreateScreen: false,
                noteData: noteData,
              )));
      await context.read<homeEvent>().getAllNoteData('date ASC',"all");
    }
  }

  //move folder
  void moveFolder(List<note> list_note) async{
    //show selected folder
    final folder result_folder = await showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context)=>modelSheetSelectedFolder()) ;

    //update local_folder
    for (int i = 0; i < checkEdit!.length; i++) {
      if (checkEdit![i] == true) {
        await context.read<homeEvent>().updateLocalFolder(list_note[i], result_folder);
      }
    }
    setState(() {
      isEdit = false;
    });
    setFalseCheckEdit();
    fetchData();
  }

  //fetch data
  void fetchData() async{
    await context.read<homeEvent>().getAllNoteData('title ASC', 'all');
    List<note>? listNote =  context.read<homeEvent>().listData;
    if(listNote != null){
      setState(() {
        checkEdit = listNote.where((e)=> e.localFolder == widget.dataFolder.id && e.isDelete == false)
            .toList()
            .map((e)=> false)
            .toList();
      });
    }

  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocBuilder<homeEvent, Home_state>(
        builder: (context, state){
          print(state);
          if(state is loadedHome){
            List<note> listData = state.noteData ?? [];
            List<note> listNoteOfFolder = listData.where((test)=> test.localFolder == widget.dataFolder.id && test.isDelete == false).toList();
            return WillPopScope(
              onWillPop: () async{
                if(isEdit){
                  setState(() {
                    isEdit = isCheckAll = false;
                  });
                  setFalseCheckEdit();
                  return false;
                }else{
                  return true;
                }
              },
              child: Scaffold(
                backgroundColor: Theme.of(context).colorScheme.background,
                body: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    SafeArea(
                      child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: NestedScrollView(
                              controller: _scrollController,
                              headerSliverBuilder: (context, innerBoxIsScrolled){
                                return [
                                  SliverToBoxAdapter(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        isEdit ? Column(
                                          children: [
                                            Transform.scale(
                                              scale:1.2,
                                              child: Checkbox(
                                                  side: BorderSide(width: 1.5, color: Theme.of(context).colorScheme.surface),
                                                  activeColor: Colors.red,
                                                  value: isCheckAll,shape: const CircleBorder(), onChanged: (value)=>checkAll(value, listNoteOfFolder)),
                                            ),
                                            Text(
                                              'Tất cả',
                                              style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.surface),
                                            )
                                          ],
                                        ) : Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            IconButton(
                                                onPressed: ()=>Navigator.pop(context),
                                                icon: Icon(Icons.arrow_back_ios_new, size: 24,color: Theme.of(context).colorScheme.surface,)
                                            ),
                                            PopupMenuButton(
                                              iconSize: 24,
                                              shape:
                                              const RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.all(
                                                      Radius
                                                          .circular(
                                                          15))),
                                              color: Theme.of(context).colorScheme.primary,
                                              itemBuilder:(context)=> [
                                                PopupMenuItem(
                                                    value: '',
                                                    child: Text(
                                                      'Sửa',
                                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400,color: Theme.of(context).colorScheme.surface),
                                                    )
                                                ),

                                              ],

                                              onSelected:(value)=>tapToEdit(listNoteOfFolder),
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Icon(Icons.folder, color: configColor.rgbaToColor(widget.dataFolder.color),size: 40,),
                                            Text(
                                              widget.dataFolder.name,
                                              style:TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.w500,
                                                  color: Theme.of(context).colorScheme.surface
                                              ),
                                            ),

                                          ],
                                        ),
                                        const Divider(thickness: 1,indent: 10,endIndent: 10,)
                                      ],
                                    ),
                                  )
                                ];
                              },
                              body:listNoteOfFolder.isEmpty ?
                              Center(
                                child: Text(
                                  'Không có ghi chú',
                                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700,color: Theme.of(context).colorScheme.surface),
                                ),
                              )
                                  : ListView.builder(
                                  itemCount: listNoteOfFolder.length,
                                  itemBuilder: (context, index)=> itemNote(listNoteOfFolder[index], index, listNoteOfFolder)
                              )
                          )
                      ),
                    ),

                    AnimatedPositioned(
                        duration: const Duration(milliseconds: 300),
                        bottom: checkEdit!.contains(true) ? 0 : -size.height * 0.1,
                        child: Container(
                          color: Theme.of(context).colorScheme.primary,
                          height: size.height * 0.1,
                          width: size.width,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              itemBottomBar(
                                  Icons.drive_folder_upload, 'Di chuyển', ()=> moveFolder(listNoteOfFolder)),
                              itemBottomBar( isLock ? Icons.lock : Icons.lock_open, isLock ? 'Khóa' : 'Mở khóa',
                                      () => lockNote(listNoteOfFolder)),
                              itemBottomBar(
                                  Icons.delete, 'Xóa', () => deleteNote(listNoteOfFolder)),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  PopupMenuButton(
                                    itemBuilder: (context) => [
                                      PopupMenuItem(
                                        value: '',
                                        child: Text( isFavorite ?  'Thêm vào mục yêu thích' : 'Bỏ khỏi mục yêu thích',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,color: Theme.of(context).colorScheme.surface)),
                                      )
                                    ],
                                    onSelected: (value) => addFavorite(listNoteOfFolder),
                                    shape: const RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(15))),
                                    color: Theme.of(context).colorScheme.primary,
                                    child: Icon(
                                      Icons.more_vert,
                                      size: 26,
                                      color: Theme.of(context).colorScheme.onSurface,
                                    ),
                                  ),
                                  Text(
                                    'Nhiều hơn',
                                    style: TextStyle(
                                        fontSize: 14, fontWeight: FontWeight.w400,color: Theme.of(context).colorScheme.onSurface),
                                  )
                                ],
                              )
                            ],
                          ),
                        )),
                  ],
                ),
              ),
            );
          }else{
            return const Scaffold();
          }
        }
    );
  }
  Widget itemNote(note note_data, int index, List<note> listnote) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: GestureDetector(
        onTap:()=> isEdit ? null : tapToSeen(note_data),
        onLongPress:() => setState(() {
          isEdit = checkEdit![index] = true;
        }),
        child: Container(
          padding:const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
          decoration:  BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              color: Theme.of(context).colorScheme.primary,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.shadow,
                  blurRadius: 2,
                  spreadRadius: 0,
                  offset:const Offset(
                    0,
                    1,
                  ),
                ),
                const BoxShadow(
                  color: Color.fromRGBO(60, 64, 67, 0.15),
                  blurRadius: 3,
                  spreadRadius: 1,
                  offset: Offset(
                    0,
                    1,
                  ),
                ),
              ]),
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // title
                  Text(
                    note_data.title,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600,color: Theme.of(context).colorScheme.surface),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  //date
                  Text(
                    '${DateTime.parse(note_data.date).day}/${DateTime.parse(note_data.date).month}/${DateTime.parse(note_data.date).year} ',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).colorScheme.onSurface),
                  ),
                  const SizedBox(
                    height: 5,
                  ),

                  //content
                  note_data.isLock
                      ? Container()
                      : Text(
                    note_data.content,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).colorScheme.surface,
                        overflow: TextOverflow.ellipsis),
                    maxLines: 4,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  //lock
                  note_data.isLock
                      ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Icon(
                          Icons.lock,
                          size: 28,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      )
                    ],
                  )
                      : Container()
                ],
              ),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 500),
                opacity:isEdit ? 1.0 : 0.0,
                child: Transform.scale(
                  scale: 1.0,
                  child: Checkbox(
                    activeColor: Colors.red,
                    side: BorderSide(color: Theme.of(context).colorScheme.surface, width: 1.5),
                    value: checkEdit![index],
                    onChanged: (value) =>EditTap (value, index,listnote ),
                    shape: const CircleBorder(),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget itemBottomBar(IconData icon, String text, Function()? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 26,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          Text(
            text,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400,color: Theme.of(context).colorScheme.onSurface),
          )
        ],
      ),
    );
  }
}
