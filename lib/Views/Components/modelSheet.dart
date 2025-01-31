import 'package:flutter/material.dart';
import 'package:flutter_application_1/Config/configColor.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Bloc/Events/ManageFolderCubit.dart';
import '../../Theme/ColorFolder.dart';

class Modelsheet extends StatefulWidget {
  final Function addFolder;
  TextEditingController controllerText;
  Modelsheet({super.key,required this.addFolder,required this.controllerText});

  @override
  State<Modelsheet> createState() => _ModelsheetState();
}

class _ModelsheetState extends State<Modelsheet> {
  int selectedColorIndex = 0;
  void tapToSelectedColor(int index){
    setState(() {
     selectedColorIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom +20
      ),
      child: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height*0.4+10,
          width:MediaQuery.of(context).size.width ,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.all(Radius.circular(25))
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Text('Tạo thư mục', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500,color: Theme.of(context).colorScheme.surface),),
              const SizedBox(height: 10,),
              TextField(
                controller: widget.controllerText,
                style: TextStyle(fontSize: 18,color: Theme.of(context).colorScheme.surface),
                decoration: const InputDecoration(
                    hintText: 'Nhập tên',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero
                ),
              ),
              Divider(thickness: 2,color: Theme.of(context).colorScheme.surface.withOpacity(0.8),height: 0,),
              const SizedBox(height: 10,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Màu' ,style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Theme.of(context).colorScheme.onSurface),),
                  Text('\t...............................................................', style: TextStyle(color: Theme.of(context).colorScheme.onSurface),)
                ],
              ),
              const SizedBox(height: 10,),
              SizedBox(
                height: MediaQuery.of(context).size.height*0.13,
                child: GridView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: listColor.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 6,
                      mainAxisSpacing: 15,
                      crossAxisSpacing: 15,
                    ),
                    itemBuilder: (context, index ){
                      return GestureDetector(
                        onTap:()=> tapToSelectedColor(index),
                        child: Container(
                          decoration: BoxDecoration(
                              color: listColor[index],
                              shape: BoxShape.circle
                          ),
                          child: selectedColorIndex == index  ?  Center(child: Icon(Icons.check, size: 26,color: Theme.of(context).colorScheme.primary,),) : null,
                        ),
                    );
                    }
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: ()=> Navigator.pop(context),
                    child: SizedBox(
                      width:MediaQuery.of(context).size.width*0.3,
                      height:MediaQuery.of(context).size.width*0.08,
                      child: const Center(
                        child: Text('Hủy', style: TextStyle(fontSize: 18, color: Colors.blueAccent, fontWeight: FontWeight.w700),),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap:(){
                      widget.addFolder(selectedColorIndex);
                    },
                    child: SizedBox(
                      width:MediaQuery.of(context).size.width*0.3,
                      height:MediaQuery.of(context).size.width*0.12,
                      child: const Center(
                        child: Text('Thêm', style: TextStyle(fontSize: 18, color: Colors.blueAccent, fontWeight: FontWeight.w700),),
                      ),
                    ),
                  ),
                ],
              )

            ],
          ),
        ),
      ),
    );
  }
}
