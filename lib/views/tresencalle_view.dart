import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lionxcode_finalproject/class/calle.dart';
import 'package:lionxcode_finalproject/class/ia_tresencallle.dart';
import 'package:lionxcode_finalproject/firebase/firestore.dart';
import 'package:lionxcode_finalproject/providers/menu_provider.dart';
import 'package:lionxcode_finalproject/widgets/linearProgress.dart';
import 'package:provider/provider.dart';

class TresEnCalleView extends StatefulWidget {

  final List<Calle> calles;
  final String uid;
  const TresEnCalleView({super.key,required this.calles,required this.uid});

  @override
  State<TresEnCalleView> createState() => _TresEnCalleViewState();
}

class _TresEnCalleViewState extends State<TresEnCalleView> {

  final Random _random = Random();
  bool miturno = true;
  List<String> jugados =["","","","","","","","",""];
  List<int> casillasGanadoras = [];
  List<int> numeros = [];
  final IaTresencallle _ia = IaTresencallle();

  @override
  Widget build(BuildContext context) {

    final noHayGanador = _ia.verificarGanador(jugados) == null;
    final sinMovimientos = _ia.calcularMovimiento(jugados) == -1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(miturno && noHayGanador
          ? (sinMovimientos ? " No hay casillas disponibles" : " Selecciona una casilla")
          : ""),
        const SizedBox(height: 20.0),
        GridView.builder(
        itemCount: jugados.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemBuilder: (_,i){
          return _caja(i);
        }),
        _mostrarGanador()
      ],
    );
  }

  Widget _caja(int index){
    
    final casillaGanadora = casillasGanadoras.contains(index);
    
    return GestureDetector(
      onTap: jugados[index] != "" || _ia.verificarGanador(jugados) != null ? null : () => _mostrarPregunta(index),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: casillaGanadora ?  const Color(0xFFCC9932)
          : jugados[index] == "" ? Colors.black12 : Colors.white,
          border: Border(
            top: index >= 3 ? const BorderSide(color: Color(0xff0f1424), width: 2) : BorderSide.none,
            left: index % 3 != 0 ? const BorderSide(color: Color(0xff0f1424), width: 2) : BorderSide.none,
          ),
        ),
        child: Text(jugados[index],style: const TextStyle(fontSize: 40)),
      ),
    );
  }

  Widget _mostrarGanador(){
    final num = _ia.calcularMovimiento(jugados);
    final lineaGanadora = _ia.verificarGanador(jugados);
   
    // Aun se puede jugar, retorna espacio vacío
    if (num != -1 && lineaGanadora == null) {
      return const SizedBox(width: 10.0);
    }
    
    // Hay ganador
    if (lineaGanadora != null) {
      final ganador = jugados[lineaGanadora[0]];
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            ganador == "O"
              ? "Demasiados\nIntentos\nFallidos !"
              : "Ganaste!\nRecibiste\n100 puntos",
          ),
          _buttonReload()
        ],
      );
    }

    // Empate
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        const Text("¡Empate!\nIntenta otra vez"),
        _buttonReload()
      ],
    );
  }

  _buttonReload(){
    final menuProvider = Provider.of<MenuProvider>(context);
    return ElevatedButton(
          onPressed: () => menuProvider.changeMateria("none"),
          child: const Text("Jugar Otra Vez"),
        );
  }

  void _mostrarPregunta(int index) async {
    final size = MediaQuery.of(context).size;
    final num = validarNumero();
    final question = getPreguntaMezclada(num);
    final res = await showModalBottomSheet(
      isScrollControlled: false,
      elevation: 2.0,
      context: context,
      builder: (context) {
        return Container( 
          width: size.width * 0.95,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.calles[num].pregunta,textAlign: TextAlign.start),
              const SizedBox(height: 10.0),
              Text("Deslize para responder",style: Theme.of(context).textTheme.bodySmall),
              const LinearTimer(),
              ...question.entries.map((opcion){
                return Dismissible(
                    key: Key(opcion.key),
                    background: Container(
                      color: const Color(0xFFCC9932),
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      child: const Icon(Icons.check, color: Color(0xff0f1424)),
                    ),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction){
                      setState(() {
                        miturno = !miturno;
                      });
                      final esCorrecta = opcion.value;

                      if (esCorrecta) {
                        setState(() {
                          jugados[index] = "X";
                          numeros.add(index);
                        });
                        
                        final ganador = _ia.verificarGanador(jugados);
                        if (ganador != null) {
                          setState(() {
                            casillasGanadoras = ganador; // ← guardamos los índices
                          });
                          Firestore(collection: "Usuarios",materia: widget.calles[0].materia).updateIntentos(widget.uid);
                          Firestore(collection: "Usuarios",materia: widget.calles[0].materia).updatePuntos(widget.uid);
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("¡Correcto!")),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Incorrecto")),
                        );
                      }
                     
                        Navigator.pop(context,"dato");
                        Future.delayed(const Duration(milliseconds: 1000), () {
                        jugadaComputadora();
                        });
                        
                        Future.delayed(const Duration(milliseconds: 1000),(){
                          setState(() {
                            miturno = !miturno;
                          });
                        });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 10.0),
                      width: double.infinity,
                      child: Text(opcion.key,style: Theme.of(context).textTheme.displayMedium)));
              })
            ],
          ),
        );
      },
    );

    if(res == null){
      setState(() {
        miturno = !miturno;
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Incorrecto")),
      );

      Future.delayed(const Duration(milliseconds: 1000), () {
        jugadaComputadora();
      });
                        
      Future.delayed(const Duration(milliseconds: 1000),(){
        setState(() {
          miturno = !miturno;
        });
      });
    }
  }

  void jugadaComputadora() {
    final int posicion = _ia.calcularMovimiento(jugados);

    if (posicion != -1 && _ia.verificarGanador(jugados) == null) {
      setState(() {
        jugados[posicion] = "O";
      });

    final ganador = _ia.verificarGanador(jugados);
      
    if (ganador != null) {  
      setState(() {
        casillasGanadoras = ganador; // ← guardamos los índices
      });
      Firestore(collection: "Usuarios",materia: widget.calles[0].materia).updateIntentos(widget.uid);
    }
    }
  }

  int validarNumero(){
    final randomIndex = _random.nextInt(widget.calles.length);

    if(numeros.contains(randomIndex)){
      return validarNumero();
    }
    else{
      return randomIndex;
    }
  }

  Map<String,bool> getPreguntaMezclada(int random){
    final Calle pregunta = widget.calles[random];
    final opcionesMezcladas = pregunta.respuestas.entries.toList();
    opcionesMezcladas.shuffle();
    
    return {
      for (var entry in opcionesMezcladas) entry.key: entry.value
    };
  }
}