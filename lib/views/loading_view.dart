import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lionxcode_finalproject/class/ahorcado.dart';
import 'package:lionxcode_finalproject/class/calle.dart';
import 'package:lionxcode_finalproject/services/shared_preferences.dart';
import 'package:lionxcode_finalproject/views/ahorcado_view.dart';
import 'package:lionxcode_finalproject/views/tresencalle_view.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class LoadinView extends StatefulWidget {
  final String juego;
  const LoadinView({super.key,required this.juego});

  @override
  State<LoadinView> createState() => _LoadinViewState();
}


class _LoadinViewState extends State<LoadinView> {

  final preferencias = PreferenciasUsuario();
  Ahorcado? preguntaSeleccionada;
  List<Calle> calles = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if(widget.juego == "Ahorcado"){
      
      if (preguntaSeleccionada == null) {
        final preguntas = Provider.of<List<Ahorcado>>(context);

        if (preguntas.isNotEmpty) {
          setState(() {
            preguntaSeleccionada = preguntas[Random().nextInt(preguntas.length)];
          });
        }
      }
    }
    else{
      final lista = Provider.of<List<Calle>>(context);
      if (calles.isEmpty && lista.isNotEmpty) {
        setState(() {
          calles = lista;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return preguntaSeleccionada == null && widget.juego == "Ahorcado" || calles.isEmpty && widget.juego != "Ahorcado" ?
      const Center(child: CircularProgressIndicator(color: Color(0xFFCC9932)))
      : widget.juego == "Ahorcado" ? AhorcadoView(ahorcado: preguntaSeleccionada!,uid: preferencias.getUid) : TresEnCalleView(calles: calles,uid: preferencias.getUid);
  }
}