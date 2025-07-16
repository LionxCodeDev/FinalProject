import 'package:flutter/material.dart';
import 'package:lionxcode_finalproject/class/ahorcado.dart';
import 'package:lionxcode_finalproject/firebase/firestore.dart';
import 'package:lionxcode_finalproject/providers/menu_provider.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
class AhorcadoView extends StatefulWidget {
  final Ahorcado ahorcado;
  final String uid;
  const AhorcadoView({super.key,required this.ahorcado,required this.uid});

  @override
  State<AhorcadoView> createState() => _AhorcadoViewState();
}

class _AhorcadoViewState extends State<AhorcadoView> with TickerProviderStateMixin {

  late VideoPlayerController _controller;
  late TextEditingController _controllerText;

  late AnimationController _animController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  bool ganador = false;
  int intentos = 0;
  String l = '';
  List<String> resp = [];
  List<String> adivinadas = [];

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/ahorcado.mp4')
    ..initialize().then((_) {
      setState(() {});
      _controller.pause();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _animController.forward(); // instancia de la animacion
      });
    });

    _controllerText = TextEditingController();
    _controllerText.text = l;

    for(int i = 0; i <= widget.ahorcado.respuesta.length - 1 ;i++){
      resp.add(widget.ahorcado.respuesta[i]);
    }

    _animController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controllerText.dispose();
    _controller.dispose(); // 👈 Libera memoria del video
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final menuProvider = Provider.of<MenuProvider>(context);
    return _controller.value.isInitialized ? SingleChildScrollView(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom,left: 5,right: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
         SizedBox(
          height: size.height * 0.35,
          width: size.width * 1,
          child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller)
          )
         ),
        SizedBox(
          height: size.height * 0.50,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(widget.ahorcado.pregunta,textAlign: TextAlign.center),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: resp.map((letra) {
                        final visible = adivinadas.contains(letra);
                        return Text(
                          visible || intentos == 5 ? letra 
                          : "_",style: const TextStyle(fontSize: 25.0));
                      }).toList() 
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: intentos != 5  && ganador == false ? [
                        _crearLetra(),
                        _bottonLetra()
                      ]
                      : [
                        Text(ganador ? "Ganaste!\nRecibiste\n100 puntos" : "Demasiados\nIntentos\nFallidos !"),
                        ElevatedButton(onPressed: () => menuProvider.changeMateria("none") , child: const Text("Nueva palabra"))
                      ]
                    )
                  ]
                ),
            ),
          ),
        )
        ],
      ),
    ) : const Center(child: SizedBox(height: 50,width: 50,child: CircularProgressIndicator(color: Color(0xFFCC9932))));
  }

  Widget _crearLetra(){
    return SizedBox(
      width: 50.0,
      child: TextFormField(
        controller: _controllerText,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.name,
        maxLength: 1,
        onChanged: (letter) {
          setState(() {
            l = letter.toUpperCase();
          });
        },
      ),
    );
  }

  Widget _bottonLetra(){
    return ElevatedButton(
      onPressed: l == '' ? null : (){
      final contiene = resp.contains(l.toUpperCase());

      if(contiene){
        setState(() {
          adivinadas.add(l.toUpperCase()); // en mayúscula si tus letras están así
          l = '';
          _controllerText.clear();
        });
        verificarVictoria();

      }else{
        manejarFallo();
      }

    }, child: const Text("Aceptar"));
  }

  void _mostrarVictoria() {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      backgroundColor: const Color(0xFFCC9932),
      title: Text("¡Ganaste! 🎉",style: Theme.of(context).textTheme.displayLarge,),
      content: Text("Adivinaste la palabra correctamente!\nGanaste 100 puntos",style: Theme.of(context).textTheme.displayMedium),
      actions: [
        TextButton(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Aceptar"),
        ),
      ],
    ),
  );
}

  void verificarVictoria() async {
    final letrasRestantes = resp.toSet().difference(adivinadas.toSet());
      if (letrasRestantes.isEmpty) {
        setState(() {
          ganador = true;
        });
        // Actualiza los intentos y los puntos
        await Firestore(collection: "Usuarios",materia: widget.ahorcado.materia).updateIntentos(widget.uid);
        await Firestore(collection: "Usuarios",materia: widget.ahorcado.materia).updatePuntos(widget.uid);
        _mostrarVictoria();
      }
  }

  void manejarFallo() async{
    setState(() {
      l = '';
      _controllerText.clear();
      intentos++;

      // Calcula la posición del video a la que debe avanzar
      final nuevaPosicion = Duration(milliseconds: 1200 * intentos);

      // Asegura que no sobrepase la duración del video
      if (nuevaPosicion <= _controller.value.duration) {
        _controller.seekTo(nuevaPosicion);
      }
    });

    // Actualiza los intentos 
    if(intentos >= 5){
      await Firestore(collection: "Usuarios",materia: widget.ahorcado.materia).updateIntentos(widget.uid);
    }
  }
}