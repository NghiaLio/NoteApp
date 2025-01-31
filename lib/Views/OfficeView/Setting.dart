import 'package:flutter/material.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter_application_1/Bloc/Events/ThemeEvent.dart';
import 'package:flutter_application_1/Theme/ThemeData.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class settingScreen extends StatefulWidget {
  const settingScreen({super.key});

  @override
  State<settingScreen> createState() => _settingScreenState();
}

class _settingScreenState extends State<settingScreen> {

  late bool positive;
  @override
  void initState() {
    ThemeData? _theme = context.read<themeEvent>().themeData;
      if(_theme == lightMode){
      positive = false;
    }else{
      positive = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:Theme.of(context).colorScheme.background ,
        leading: IconButton(
            onPressed: ()=> Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios_new, size: 24,color:Theme.of(context).colorScheme.surface ,)
        ),
        title: Text(
          'Cài đặt',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Theme.of(context).colorScheme.surface),
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text(
              'Chủ đề',
              style: TextStyle(fontSize: 18, color: Theme.of(context).colorScheme.surface),
            ),
            trailing:AnimatedToggleSwitch<bool>.dual(
              current: positive,
              first: false,
              second: true,
              spacing: 10.0,
              style: ToggleStyle(
                backgroundColor: Theme.of(context).colorScheme.background ,
                borderColor: Colors.transparent,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.shadow,
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset:const Offset(0, 1.5),
                  ),
                ],
              ),
              borderWidth: 5.0,
              height: 30,
              onChanged: (b) {
                setState(() => positive = b);
                context.read<themeEvent>().changeTheme(b ? darkMode : lightMode );
              } ,
              styleBuilder: (b) => ToggleStyle(
                  indicatorColor: b ? Colors.green : Colors.red),
              iconBuilder: (value) => value
                  ? const Icon(Icons.dark_mode, color: Colors.yellow,size: 20,)
                  : const Icon(Icons.light_mode,color: Colors.yellow,size: 20,),
              textBuilder: (value) => value
                  ?  Center(child: Text('Tối', style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.surface),))
                  :  Center(child: Text('Sáng', style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.surface))),
            ),
          )
        ],
      ),
    );
  }
}
