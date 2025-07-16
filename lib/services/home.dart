import 'package:flutter/material.dart';
import 'package:lionxcode_finalproject/class/usuarios.dart';
import 'package:lionxcode_finalproject/firebase/firestore.dart';
import 'package:lionxcode_finalproject/pages/login_page.dart';
import 'package:lionxcode_finalproject/pages/juegos_page.dart';
import 'package:lionxcode_finalproject/pages/perfil_page.dart';
import 'package:lionxcode_finalproject/providers/menu_provider.dart';
import 'package:lionxcode_finalproject/providers/provider.dart';
import 'package:lionxcode_finalproject/services/shared_preferences.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  late dynamic uid;
  late MenuProvider menuProvider;

  @override
  void initState() {
    uid = PreferenciasUsuario().getUid;
    super.initState();
  }

  @override
  Widget build(BuildContext context) { 
    menuProvider = Provider.of<MenuProvider>(context);  
    return Scaffold(
      appBar: uid == null || uid == "none" || menuProvider.getjuego() == "none" ? null : _appBar(),
      body: uid == null || uid == "none" ? Provide(key: const Key('key-user'), child: const LogInPage())
        : PageView(
          controller: menuProvider.controller,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            JuegosPage(),
            
            StreamProvider<List<Usuarios>>.value(
            initialData: const [],
            value: Firestore(collection: "Usuarios").usuarios,
            child: const PerfilPage())
          ],
        ),
      bottomNavigationBar: uid == null || uid == "none" || menuProvider.getjuego() != "none" ? null : _bottomNavigation(),  
    );
  }

  PreferredSizeWidget _appBar(){
    return AppBar(
      backgroundColor: const Color(0xFFCC9932),
      elevation: 2,
      title: Text(menuProvider.getjuego(),style: Theme.of(context).textTheme.titleMedium),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 5.0),
          child: IconButton(
            color: Colors.white,//const Color(0xff0f1424),
            style: ButtonStyle( backgroundColor:  WidgetStateProperty.all<Color>(const Color(0xff0f1424))),
            onPressed: () {
              menuProvider.changeJuego("none");
              menuProvider.changeMateria("none");
            }, icon: const Icon(Icons.close))),
      ],
    );
  }

  Widget _bottomNavigation(){
    return BottomNavigationBar(
      onTap: (pos){
        menuProvider.changePage(pos);
      },
      currentIndex: menuProvider.getPosPage(),
      elevation: 2.0,
      items: const [
      BottomNavigationBarItem(icon: Icon(Icons.games_rounded),label: "Jugar"),
      BottomNavigationBarItem(icon: Icon(Icons.person),label: "Perfil")
    ]);
  }
}