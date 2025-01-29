// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Models/Data/folder.dart';
import '../../Bloc/Events/LayoutCubit.dart';
import '../../Bloc/Events/Navigation.dart';
import '../../Bloc/Events/SortNote.dart';
import '../../Bloc/Events/HomeEvent.dart';
import '../../Bloc/States/HomeState.dart';
import '../../Models/Data/note.dart';
import '../Components/DialogPassword.dart';
import '../Components/modelSheetSelectedFolder.dart';
import 'NoteScreen.dart';
import '../../Bloc/Events/openDrawer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'Search.dart';

class Home extends StatefulWidget {
  String Screen;

  String headerTitle;
  Function()? openDrawer;

  Home(
      {Key? key,
      this.openDrawer,
      required this.Screen,
      required this.headerTitle}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();

}

class _HomeState extends State<Home> {
  ScrollController _scrollController = ScrollController();
  double TitleOpacityLevel = 1.0;
  double menuTitleOpacityLevel = 0.0;
  bool isEdit = false;
  bool isCheckAll = false;
  String? initialLayout = 'luoi-vua';
  bool isLock = false;
  bool isFavorite = false;


  final passController = TextEditingController();

  List<int> testList = List.generate(15, (index) => index);

  List<bool>? checkEdit;

  final GlobalKey _menuButtonKey = GlobalKey();





  //navigated to searchview
  void tapToSearchView() {
    Navigator.push(
        context, MaterialPageRoute(builder: (c) => const SearchView()));
  }

  //sort by
  void selectedSort(Object? values) async {
    await context.read<SortCubit>().changeNameSort(values!);
    fetchData();
  }

  //icon sort selected
  void iconSelectedSort(String value) async {
    await context.read<SortCubit>().changeCurrentSort(value);
    fetchData();
  }

  void showMenuStyle(Object? value) {
    if (value! == 'watch') {
      selectedStyleScreen();
    } else if (value == 'edit') {
      setState(() {
        isEdit = true;
      });
    }
  }

  //show menu style screnn
  void selectedStyleScreen() {
    // Lấy kích thước và vị trí của nút bấm
    final RenderBox renderBox =
        _menuButtonKey.currentContext!.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;

    showMenu(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))),
            color: Theme.of(context).colorScheme.primary,
            context: context,
            position: RelativeRect.fromLTRB(
                offset.dx, // Tọa độ x của nút
                offset.dy + size.height, // Tọa độ y ngay dưới nút
                offset.dx + size.width, // Độ rộng của nút
                0),
            items: [
          PopupMenuItem(
            value: 'luoi-nho',
            child: Text(
              'Lưới (nhỏ)',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: initialLayout == 'luoi-nho'
                      ? Colors.deepOrange
                      : Theme.of(context).colorScheme.surface),
            ),
          ),
          PopupMenuItem(
            value: 'luoi-vua',
            child: Text(
              'Lưới (vừa)',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: initialLayout == 'luoi-vua'
                      ? Colors.deepOrange
                      : Theme.of(context).colorScheme.surface),
            ),
          ),
          // PopupMenuButton(itemBuilder: itemBuilder),
          PopupMenuItem(
            value: 'danh-sach',
            child: Text(
              'Danh sách',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: initialLayout == 'danh-sach'
                      ? Colors.deepOrange
                      : Theme.of(context).colorScheme.surface),
            ),
          ),
        ]) // select item
        .then((value) {
      if (value != null) {
        setState(() {
          initialLayout = value;
        });
        context.read<LayoutCubit>().changeLayout(value);
      }
    });
  }

  //xem thông tin note
  void tapToSeen(note noteData) async {
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
      fetchData();
    }
  }

  // check and set icon & text lock and favorite
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
    check.forEach(
        (e){
          if(e.isLock == true){
            numLock++;
          }
          if(e.isFavorite == true){
             numFavorite++;
          }
        }
    );
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

  // write new note
  void writeNewNote() async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (c) => Notescreen(
                  isCreateScreen: true,
                )));
    // reload
    fetchData();
  }

  //deleteNote
  void deleteNote(List<note> list_note) async {
    for (int i = 0; i < checkEdit!.length; i++) {
      if (checkEdit![i] == true) {
        if(widget.Screen == 'cyclebin'){
          context.read<homeEvent>().deleteNote(list_note[i].id!);
        }else{
          context.read<homeEvent>().updateDelete(list_note[i]);
        }
      }
    }
    // ẩn bottom
    checkEdit = checkEdit!.map((e) => false).toList();
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
        context.read<homeEvent>().updateFavorite(list_note[i]);
      }
    }
    checkEdit = checkEdit!.map((e) => false).toList();
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
    checkEdit = checkEdit!.map((e) => false).toList();

  }

  void fetchData() async {

    await context.read<SortCubit>().getSort();
    String nameSort = context.read<SortCubit>().nameSort;
    String currenSort = context.read<SortCubit>().currentSort;
    if (nameSort == 'Tiêu đề') {
      await context.read<homeEvent>().getAllNoteData('title $currenSort',widget.Screen);
    } else if (nameSort == 'Ngày tạo') {
      await context.read<homeEvent>().getAllNoteData('date $currenSort',widget.Screen);
    } else if (nameSort == 'Ngày sửa đổi') {
      await context.read<homeEvent>().getAllNoteData('dateChange $currenSort',widget.Screen);
    }
    // set up check box value
    List<note>? listData = context.read<homeEvent>().listData;
    
    if (listData != null) {
      if(widget.Screen == 'all'){
        listData = listData.where((e)=>e.isDelete == false).toList();
      }else if(widget.Screen == 'lock'){
        listData = listData.where((e)=>e.isLock == true && e.isDelete == false).toList();
      }else if(widget.Screen == 'favorite'){
        listData = listData.where((e)=>e.isFavorite == true && e.isDelete == false).toList();
      }else if(widget.Screen == 'cyclebin'){
        listData = listData.where((e)=>e.isDelete == true).toList();
      }
      setState(() {
        checkEdit = listData!.map((e) => false).toList();
      });
    }

  }

  void layOut() async {
    await context.read<LayoutCubit>().getLayout();
    setState(() {
      initialLayout = context.read<LayoutCubit>().state.nameLayout;
    });
  }

  @override
  void initState() {
    //control scroll
    _scrollController.addListener(() {
      setState(() {
        double scrollPosition = _scrollController.position.pixels;
        double maxExtent = _scrollController
            .position.maxScrollExtent; // Độ dài tối đa để thay đổi opacity

        TitleOpacityLevel = (1.0 - scrollPosition / maxExtent).clamp(0.0, 1.0);
        menuTitleOpacityLevel = (scrollPosition / maxExtent).clamp(0.0, 1.0);
      });
    });
    // get data
    fetchData();
    // set layout
    layOut();
    // after back from other page , checkEdit is initialed, mve coday be remoe because fetchData is contained
    List<note>? listData = context.read<homeEvent>().listData;
    if (listData != null) {
      if(widget.Screen == 'all'){
        listData = listData.where((e)=>e.isDelete == false).toList();
      }else if(widget.Screen == 'lock'){
        listData = listData.where((e)=>e.isLock == true && e.isDelete == false).toList();
      }else if(widget.Screen == 'favorite'){
        listData = listData.where((e)=>e.isFavorite == true && e.isDelete == false).toList();
      }else if(widget.Screen == 'cyclebin'){
        listData = listData.where((e)=>e.isDelete == true).toList();
      }
      setState(() {
        checkEdit = listData!.map((e) => false).toList();
      });
    }

    super.initState();
  }

  @override
  void didChangeDependencies() {
    fetchData();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isOpenDrawer = context.read<Opendrawer>().state;
    List<PopupMenuEntry<Object?>> listOption = [
       PopupMenuItem(
        value: 'edit',
        child: Text(
          'Sửa',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Theme.of(context).colorScheme.surface),
        ),
      ),
       PopupMenuItem(
        value: 'watch',
        child: Text(
          'Xem',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400,color: Theme.of(context).colorScheme.surface),
        ),
      ),
       PopupMenuItem(
        value: 'favorite',
        child: Text(
          'Ghim mục yêu thích lên đầu',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400,color: Theme.of(context).colorScheme.surface),
        ),
      ),
    ];
    List<PopupMenuEntry<Object?>> listSortItem = [
      PopupMenuItem(
        value: 'Tiêu đề',
        child: Text(
          'Tiêu đề',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400,color: Theme.of(context).colorScheme.surface),
        ),
      ),
      PopupMenuItem(
        value: 'Ngày tạo',
        child: Text(
          'Ngày tạo',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Theme.of(context).colorScheme.surface),
        ),
      ),
      PopupMenuItem(
        value: 'Ngày sửa đổi',
        child: Text(
          'Ngày sửa đổi',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400,color: Theme.of(context).colorScheme.surface),
        ),
      ),
    ];
    return BlocConsumer<homeEvent, Home_state>(
      builder: (context, state) {
        print(state);
        if (state is loadedHome) {
          List<note> list_note = state.noteData ?? [];
          if(widget.Screen == 'all'){
            list_note = list_note.where((e)=>e.isDelete == false).toList();
          }else if(widget.Screen == 'lock'){
            list_note = list_note.where((e)=>e.isLock == true && e.isDelete == false).toList();
          }else if(widget.Screen == 'favorite'){
            list_note = list_note.where((e)=>e.isFavorite == true && e.isDelete == false).toList();
          }else if(widget.Screen == 'cyclebin'){
            list_note = list_note.where((e)=>e.isDelete == true).toList();
          }
          return WillPopScope(
            onWillPop: () async {
              setState(() {
                checkEdit = checkEdit!.map((e) => false).toList();
                isEdit = false;
              });
              return false;
            },
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                GestureDetector(
                  onTap: isOpenDrawer ? widget.openDrawer : null,
                  child: Container(
                    color: Theme.of(context).colorScheme.background,
                    height: size.height,
                    width: size.width,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 25, left: 10, right: 10),
                      child: NestedScrollView(
                          controller: _scrollController,
                          headerSliverBuilder: (context, innerBoxIsScrolled) {
                            return [
                              SliverToBoxAdapter(
                                child: SizedBox(
                                  height: size.height * 1 / 4,
                                  width: size.width,
                                  child: Center(
                                    child: AnimatedOpacity(
                                        duration:
                                            const Duration(milliseconds: 200),
                                        opacity: TitleOpacityLevel,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              widget.headerTitle,
                                              style: TextStyle(
                                                  fontSize: 40,
                                                  fontWeight: FontWeight.w600,
                                                color: Theme.of(context).colorScheme.surface
                                              ),
                                            ),
                                            Text(
                                              '${list_note.length}',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Theme.of(context).colorScheme.onSurface),
                                            )
                                          ],
                                        )),
                                  ),
                                ),
                              )
                            ];
                          },
                          body: Wrap(
                            children: [
                              //Tab bar
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: SizedBox(
                                  height: size.height * 1 / 10 - 15,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          !isEdit
                                              ? IconButton(
                                                  onPressed: widget.openDrawer,
                                                  icon: Icon(
                                                    Icons.menu,
                                                    size: 35, color: Theme.of(context).colorScheme.surface
                                                  ))
                                              : Column(
                                                  children: [
                                                    Transform.scale(
                                                      scale: 1.5,
                                                      child: Checkbox(
                                                        value: isCheckAll,
                                                        activeColor: Colors.red,
                                                        side: BorderSide(color: Theme.of(context).colorScheme.surface,width: 1.5),
                                                        onChanged: (value) =>
                                                            checkAll(value, list_note),
                                                        shape:
                                                            const CircleBorder(),
                                                      ),
                                                    ),
                                                    Text(
                                                      'Tất cả',
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Theme.of(context).colorScheme.surface
                                                      ),
                                                    )
                                                  ],
                                                ),
                                          AnimatedOpacity(
                                            duration: const Duration(
                                                milliseconds: 200),
                                            opacity: isEdit
                                                ? 1.0
                                                : menuTitleOpacityLevel,
                                            child: Text(
                                              !isEdit
                                                  ? 'Tất cả ghi chú'
                                                  : 'Chọn ghi chú',
                                              style: TextStyle(
                                                  fontSize: 26,
                                                  fontWeight: FontWeight.w500,
                                                  color: Theme.of(context).colorScheme.surface
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      !isEdit
                                          ? Row(
                                              children: [
                                                IconButton(
                                                    onPressed: tapToSearchView,
                                                    icon: Icon(
                                                      Icons.search,
                                                      size: 30,
                                                        color: Theme.of(context).colorScheme.surface
                                                    )),
                                                Theme(
                                                  data: Theme.of(context).copyWith(
                                                    popupMenuTheme:const PopupMenuThemeData(
                                                        textStyle: TextStyle(color:Colors.black,fontSize: 22, fontWeight: FontWeight.w400)
                                                    )
                                                  ),
                                                  child: PopupMenuButton(
                                                    key: _menuButtonKey,
                                                    itemBuilder: (context) =>
                                                        listOption,
                                                    iconSize: 32,
                                                    shape:
                                                        const RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius
                                                                        .circular(
                                                                            15))),
                                                    color: Theme.of(context).colorScheme.primary,

                                                    onSelected: (value) =>
                                                        showMenuStyle(value),
                                                  ),
                                                ),
                                              ],
                                            )
                                          : Container()
                                    ],
                                  ),
                                ),
                              ),
                              //list item
                              list_note.isNotEmpty
                                  ? Column(
                                      children: [
                                        BlocBuilder<SortCubit, SortState>(
                                            builder: (context, stateSort) {
                                          String nameSort = stateSort.nameSort;
                                          String currentSort =
                                              stateSort.currentSort;
                                          return Row(
                                            children: [
                                              Expanded(
                                                child: Container(),
                                              ),
                                              PopupMenuButton(
                                                itemBuilder: (context) =>
                                                    listSortItem,
                                                onSelected: (Object? values) =>
                                                    selectedSort(values),
                                                shape:
                                                    const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    15))),
                                                color: Theme.of(context).colorScheme.primary,
                                                child: Text(
                                                  nameSort,
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color:
                                                      Theme.of(context).colorScheme.onSurface),
                                                ),
                                              ),
                                              IconButton(
                                                  onPressed: () {
                                                    if (currentSort == 'DESC') {
                                                      iconSelectedSort('ASC');
                                                    } else {
                                                      iconSelectedSort('DESC');
                                                    }

                                                    // fetchData();
                                                  },
                                                  icon: Icon(
                                                    currentSort == 'DESC'
                                                        ? Icons.arrow_downward
                                                        : Icons.arrow_upward,
                                                    size: 24,
                                                    color: Theme.of(context).colorScheme.onSurface,
                                                  ))
                                            ],
                                          );
                                        }),
                                        BlocBuilder<LayoutCubit, LayoutState>(
                                            builder: (context, state) {
                                          final String? nameLayout =
                                              state.nameLayout;
                                          return SizedBox(
                                            height: size.height * 0.8,
                                            child: nameLayout != 'danh-sach'
                                                ? GridView.builder(
                                                    padding:
                                                        const EdgeInsets.all(0),
                                                    itemCount: list_note.length,
                                                    gridDelegate:
                                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                                            crossAxisCount: 3,
                                                            mainAxisSpacing: 15,
                                                            crossAxisSpacing:
                                                                15,
                                                            childAspectRatio:
                                                                2 / 3.8),
                                                    itemBuilder: (context,
                                                            index) =>
                                                        ItemNote(
                                                            list_note[index],
                                                            index,
                                                            nameLayout,
                                                            list_note
                                                        ))
                                                : ListView.builder(
                                                    padding: EdgeInsets.zero,
                                                    itemCount: list_note.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return ItemNoteForListView(
                                                          list_note[index],
                                                          index,list_note
                                                      );
                                                    }),
                                          );
                                        })
                                      ],
                                    )
                                  : SizedBox(
                                      height: size.height * 0.5,
                                      child: Center(
                                        child: Text(
                                          'Không có ghi chú',
                                          style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.w600,
                                              color: Theme.of(context).colorScheme.surface
                                          ),
                                        ),
                                      ),
                                    )
                            ],
                          )),
                    ),
                  ),
                ),

                //Bottom bar selection
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
                              Icons.drive_folder_upload, 'Di chuyển', ()=>moveFolder(list_note)),
                          itemBottomBar( isLock ? Icons.lock : Icons.lock_open, isLock ? 'Khóa' : 'Mở khóa',
                              () => lockNote(list_note)),
                          itemBottomBar(
                              Icons.delete, widget.Screen == 'cyclebin' ? 'Xóa vĩnh viễn' : 'Xóa', () => deleteNote(list_note)),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              PopupMenuButton(
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    value: '',
                                    child: Text( isFavorite ?  'Thêm vào mục yêu thích' : 'Bỏ khỏi mục yêu thích',
                                        style:TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400,color: Theme.of(context).colorScheme.surface)),
                                  )
                                ],
                                onSelected: (value) => addFavorite(list_note),
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15))),
                                color: Theme.of(context).colorScheme.primary,
                                child: Icon(
                                  Icons.more_vert,
                                  size: 30,
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                              Text(
                                'Nhiều hơn',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w400,color: Theme.of(context).colorScheme.onSurface),
                              )
                            ],
                          )
                        ],
                      ),
                    )),

                //Button new note
                isEdit
                    ? Container()
                    : Positioned(
                        bottom: size.height * 0.04,
                        right: size.height * 0.02,
                        child: GestureDetector(
                          onTap: writeNewNote,
                          child: Container(
                            height: size.height * 0.08,
                            width: size.height * 0.08,
                            decoration:  BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Theme.of(context).colorScheme.shadow,
                                    blurRadius: 4,
                                    spreadRadius: 0,
                                    offset:const Offset(0, 1),
                                  ),
                                ]),
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.edit,
                              color: Colors.amber,
                              size: 35,
                            ),
                          ),
                        ),
                      )
              ],
            ),
          );
        } else {
          return SizedBox(
              height: size.height,
              width: size.width,
              child: const Center(child: CircularProgressIndicator()));
        }
      },
      listener: (context, state) {
        if (state is deleteSucces) {
          setState(() {
            isEdit = false;
          });
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('delete success')));
          fetchData();
        }
        if (state is updateSucees) {
          setState(() {
            isEdit = false;
          });
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('note is locked')));
          fetchData();
        }
      },
    );
  }

  Widget ItemNote(note note_data, int index, String? nameLayout, List<note> listNote) {
    final sizeHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () => tapToSeen(note_data),
      onLongPress: () => setState(() {
        isEdit = checkEdit![index] = true;
      }),
      child: Column(
        children: [
          Container(
            height: nameLayout == 'luoi-vua'
                ? sizeHeight * 0.2 - 20
                : sizeHeight * 0.1,
            decoration:  BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                color: Theme.of(context).colorScheme.primary,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.shadow,
                    blurRadius: 2,
                    spreadRadius: 0,
                    offset: const Offset(
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
              children: [
                Center(
                  child: note_data.isLock
                      ? Icon(
                          Icons.lock,
                          size: 30,
                          color: Theme.of(context).colorScheme.onSurface,
                        )
                      : Text(
                          note_data.content,
                          style: TextStyle(
                              fontSize: 16, overflow: TextOverflow.ellipsis,color: Theme.of(context).colorScheme.surface),
                          maxLines: null,
                        ),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isEdit ? 1.0 : 0.0,
                  child: Transform.scale(
                    scale: 1.2,
                    child: Checkbox(
                      activeColor: Colors.red,
                      side: BorderSide(color: Theme.of(context).colorScheme.surface,width: 1.5),
                      value: checkEdit![index],
                      onChanged: (value) =>
                          isEdit ? EditTap(value, index,listNote) : null,
                      shape: const CircleBorder(

                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          //Title
          Text(
            note_data.title,
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.surface,
                overflow: TextOverflow.ellipsis),
          ),
          //date
          Text(
            '${DateTime.parse(note_data.date).day}-${DateTime.parse(note_data.date).month}-${DateTime.parse(note_data.date).year}',
            style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w400),
          )
        ],
      ),
    );
  }

  Widget ItemNoteForListView(note note_data, int index, List<note> listNote) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: GestureDetector(
        onTap: () => tapToSeen(note_data),
        onLongPress: () => setState(() {
          isEdit = checkEdit![index] = true;
        }),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
          decoration:  BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              color: Theme.of(context).colorScheme.primary,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.shadow,
                  blurRadius: 2,
                  spreadRadius: 0,
                  offset: const Offset(
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
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  //date
                  Text(
                    '${DateTime.parse(note_data.date).day}/${DateTime.parse(note_data.date).month}/${DateTime.parse(note_data.date).year} ',
                    style: TextStyle(
                        fontSize: 16,
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
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
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
                opacity: isEdit ? 1.0 : 0.0,
                child: Transform.scale(
                  scale: 1.2,
                  child: Checkbox(
                    activeColor: Colors.red,
                    value: checkEdit![index],
                    onChanged: (value) => EditTap(value, index,listNote),
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
            size: 30,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          Text(
            text,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          )
        ],
      ),
    );
  }
}
