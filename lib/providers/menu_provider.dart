
import 'package:flutter/material.dart';

class MenuProvider extends ChangeNotifier {
  
  PageController controller = PageController(initialPage: 0);
  int currentPage = 0;
  String juego = "none";
  String materia = "none";


  void changePage(int pos) {
    currentPage = pos;
    controller.jumpToPage(pos);
    notifyListeners();
  }

  void changeJuego(String play){
    juego = play;
    notifyListeners();
  }

  void changeMateria(String asignatura){
    materia = asignatura;
    notifyListeners();
  }

  int getPosPage(){
    return currentPage;
  }

  String getjuego(){
    return juego;
  }

  String getmateria(){
    return materia;
  }
}
