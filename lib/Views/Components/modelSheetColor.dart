import 'package:flutter/material.dart';
import 'package:flutter_application_1/Theme/ColorFolder.dart';

class modelSheetColor extends StatefulWidget {
  final Function updateColor;
  const modelSheetColor({super.key, required this.updateColor});

  @override
  State<modelSheetColor> createState() => _modelSheetColorState();
}

class _modelSheetColorState extends State<modelSheetColor> {
  int? currentIndexColor;

  void tapToSelectedColor(int index){
    setState(() {
      currentIndexColor = index;
    });
    widget.updateColor(currentIndexColor);
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

          decoration:  BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.all(Radius.circular(20))
          ),
          height: MediaQuery.of(context).size.height*0.27,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Thay đổi màu thư mục',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700,color: Theme.of(context).colorScheme.surface),
              ),
              const SizedBox(height: 10,),
              SizedBox(
                height:MediaQuery.of(context).size.height*0.13 ,
                width: MediaQuery.of(context).size.width,
                child: GridView.builder(
                  itemCount: listColor.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 6,
                      mainAxisSpacing: 15,
                      crossAxisSpacing: 15
                    ),
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: ()=>tapToSelectedColor(index),
                      child: Container(
                        decoration: BoxDecoration(
                          color: listColor[index],
                          shape: BoxShape.circle
                        ),
                        child: currentIndexColor == index ?  Center(child: Icon(Icons.check, color: Theme.of(context).colorScheme.primary,size: 28,),) : null,
                      ),
                    )
                ),
              ),
              Center(
                child: GestureDetector(
                  onTap: ()=> Navigator.pop(context),
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    child: const Text(
                      'Hủy',
                      style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600, color: Colors.blueAccent),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
