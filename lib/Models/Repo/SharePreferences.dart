import 'package:shared_preferences/shared_preferences.dart';

class repoSharePreferences{
  repoSharePreferences();

  //Sort
  Future<void> setSort(String nameSort, String currentSort) async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('nameSort', nameSort);
    prefs.setString('currentSort', currentSort);
  }

  Future<List<String?>> getSort() async{
    final prefs = await SharedPreferences.getInstance();
    String? nameSort = prefs.getString('nameSort');
    String? currentSort = prefs.getString('currentSort');
    return [nameSort, currentSort];
  }
  //Layout
  Future<void> setLayout(String nameLayout) async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('nameLayout', nameLayout);
  }

  Future<String?> getLayout() async{
    final prefs =await SharedPreferences.getInstance();
    String? nameLayout = prefs.getString('nameLayout');
    return nameLayout;
  }
  //Navigation
  Future<void> setNavigatior(int indexScreen)async{
      final prefs = await SharedPreferences.getInstance();
      prefs.setInt('currentIndex', indexScreen);
  }

  Future<int?> getNavigator() async{
    final prefs = await SharedPreferences.getInstance();
    final currentIndex = prefs.getInt('currentIndex');
    return currentIndex;
  }

  //Theme
  Future<void> setTheme(String theme) async{
    final prefs =await SharedPreferences.getInstance();
    prefs.setString('theme', theme);
  }
  Future<String?> getTheme() async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('theme');
  }
}