abstract class NavigationState{}

class initialNavigator extends NavigationState{}

class loadNavigator extends NavigationState{}

class loadedNavigator extends NavigationState {
  final int currentIndex;
  loadedNavigator(this.currentIndex);
}