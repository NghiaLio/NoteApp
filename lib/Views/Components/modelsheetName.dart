import 'package:flutter/material.dart';

class modelSheetName extends StatelessWidget {
  final Function updateName;
  TextEditingController textController;

  modelSheetName({super.key, required this.textController, required this.updateName});

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
        decoration:  BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: const BorderRadius.all(Radius.circular(20))
        ),
        height: MediaQuery.of(context).size.height*0.23,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Thay đổi tên thư mục',
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.w700,color: Theme.of(context).colorScheme.surface),
            ),
            const SizedBox(height: 15,),
            TextField(
              controller: textController,
              style: TextStyle(fontSize: 22,color: Theme.of(context).colorScheme.surface),
              decoration: const InputDecoration(
                  hintText: 'Nhập tên',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero
              ),
            ),
            Divider(thickness: 2,color: Theme.of(context).colorScheme.surface.withOpacity(0.8),height: 0,),
            const SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: ()=> Navigator.pop(context),
                  child: SizedBox(
                    width:MediaQuery.of(context).size.width*0.3,
                    height:MediaQuery.of(context).size.width*0.12,
                    child: const Center(
                      child: Text('Hủy', style: TextStyle(fontSize: 22, color: Colors.blueAccent, fontWeight: FontWeight.w700),),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap:()=> updateName(),
                  child: SizedBox(
                    width:MediaQuery.of(context).size.width*0.3,
                    height:MediaQuery.of(context).size.width*0.12,
                    child: const Center(
                      child: Text('Thêm', style: TextStyle(fontSize: 22, color: Colors.blueAccent, fontWeight: FontWeight.w700),),
                    ),
                  ),
                ),
              ],
            )
          ],
        )
      )
    )
    );
  }
}
