import 'package:flutter/material.dart';
import 'package:flutter_application_1/Models/Data/folder.dart';
import '../../Bloc/Events/ManageFolderCubit.dart';
import '../../Bloc/Events/NoteScreenEvent.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_modal_sheet/top_modal_sheet.dart';
import '../../Config/configColor.dart';
import '../../Models/Data/note.dart';
import '../Components/Topsheet.dart';

class Notescreen extends StatefulWidget {
  bool isCreateScreen;
  note? noteData;
  Notescreen({super.key, required this.isCreateScreen, this.noteData});

  @override
  State<Notescreen> createState() => _NotescreenState();
}

class _NotescreenState extends State<Notescreen> {
  TextEditingController contentController = TextEditingController();

  // initial screen setup for create
  final FocusNode _focusNode = FocusNode();
  String? titleText;
  bool isFavorite = false;
  bool? isHaveTitle;
  folder? dataFolder;

  //show top sheet to edit Title
  Future<void> _showTop() async {
    final value = await showTopModalSheet<Map<String, dynamic>>(
      context,
      MyTopSheet(
        titleText: titleText!,
        isFavorite: isFavorite,
        dataFolder: dataFolder,
      ),
    );

    setState(() {
      titleText = value!['textTitle'];
      isFavorite = value['isFavorite'];
      dataFolder = value['folder'];
      isHaveTitle = true;
    });

    print(isFavorite);
    print(value!['folder']);
  }

  // update
  Future<void> update() async {
    if (widget.isCreateScreen) {
      await context.read<noteScreenEvent>().createNote(
          contentController.text.trim(),
          titleText!,
          isFavorite,
          dataFolder!.id);
    } else {
      await context.read<noteScreenEvent>().updateNote(
          contentController.text.trim(),
          titleText!,
          isFavorite,
          dataFolder!.id,
          widget.noteData!);
    }
  }

  void backTap() async {
    //pop screen
    if (isHaveTitle!) {
      bool checkFocus = _focusNode.hasFocus;
      if (!checkFocus) {
        await update();
        Navigator.pop(context);
      } else {
        _focusNode.unfocus();
      }
    } else {
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    List<folder> listFolder =
        context.read<manageFolderCubit>().listFolder ?? [];
    // setup for update screen
    if (!widget.isCreateScreen) {
      setState(() {
        titleText = widget.noteData!.title;
        isFavorite = widget.noteData!.isFavorite;
        contentController.text = widget.noteData!.content;
        dataFolder = listFolder.firstWhere(
            (e) => e.id == widget.noteData!.localFolder,
            orElse: () => folder(
                id: null,
                name: 'Thư mục',
                color: configColor.colorToRGBA(Colors.grey.shade500)));
        isHaveTitle = true;
      });
    } else {
      setState(() {
        titleText = 'Tiêu đề';
        isHaveTitle = false;
        dataFolder = folder(
            id: null,
            name: 'Thư mục',
            color: configColor.colorToRGBA(Colors.grey.shade500));
      });
    }

    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          leading: IconButton(
              onPressed: backTap,
              icon: Icon(
                Icons.arrow_back_ios_new,
                size: 30, color: Theme.of(context).colorScheme.surface
              )),
          title: GestureDetector(
            onTap: _showTop,
            child: Text(
              titleText!,
              style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: !isHaveTitle!
                      ? Theme.of(context).colorScheme.onSurface
                      : Theme.of(context).colorScheme.surface),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Container(
            height: size.height * 0.9,
            color: Theme.of(context).colorScheme.primary,
            child: TextField(
              focusNode: _focusNode,
              controller: contentController,
              decoration: const InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                border: InputBorder.none,
              ),
              style:  TextStyle(fontSize: 22, fontWeight: FontWeight.w400, color:Theme.of(context).colorScheme.surface ),
              cursorColor: Colors.red,
              maxLines: null,
            ),
          ),
        ));
  }
}
