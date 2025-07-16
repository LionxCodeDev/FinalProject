import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lionxcode_finalproject/firebase/auth.dart';
import 'package:lionxcode_finalproject/providers/login_block.dart';
import 'package:lionxcode_finalproject/providers/provider.dart';


class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {

  bool cargando = false;
  bool login = true;
  late LoginBlock block;
  late Size size;
  final auth = AuthFirebase();

  @override
  Widget build(BuildContext context) {
    block = Provide.of(context);
    size = MediaQuery.of(context).size;
    return SingleChildScrollView(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _portada(),
              Container(
                height: login ? size.height * 0.50 : size.height * 0.55,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: cargando ? const Center(child: CircularProgressIndicator(color: Color(0xFFCC9932))) : Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if(!login)_showName(),
                   _showEmail(),
                   _showPassword(context),
                   login ?_buttonLogIn() : _buttonRegister()
                ],
              )),
              SizedBox(height: login ? size.height * 0.05 : size.height * 0.01),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Text( login? "¿No tienes una cuenta?" : "¿Ya posees una cuenta?",style: Theme.of(context).textTheme.bodySmall),
                TextButton(
                  onPressed: !cargando ? () {
                    setState((){
                      login = !login;
                    });
                  } : null,
                  child: Text( login? 'Regístrate Aquí' : "LogIn Aquí",style: Theme.of(context).textTheme.labelSmall))
              ])
            ],
          ),
    );
  }

  _portada(){
    return SizedBox(
      height: size.height * 0.35,
      width: double.infinity,
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _titulo(" J"," uega"),
              _titulo("   A"," prende"),
              _titulo("     P"," ractica"),
              SizedBox(height: size.height * 0.03)
          ]),
          Positioned(
            right: 0,
            bottom: 0,
            child: Image.asset('assets/foco.png',width: size.width * 0.9,fit: BoxFit.fitWidth))
        ],
      ),
    );
  }

  _titulo(String letra, String txt){
    return Row(children: [
      Text(letra,style: Theme.of(context).textTheme.titleLarge),
      Text(txt,style: Theme.of(context).textTheme.titleMedium),
    ],);
  }

  _showEmail(){
  return StreamBuilder(
    stream: block.emailStream, 
    builder: (BuildContext context, AsyncSnapshot snapshot){
      return TextFormField(
        style: Theme.of(context).textTheme.bodySmall,
        keyboardType: TextInputType.text,
        cursorColor: const Color(0xff0f1424),
        inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.singleLineFormatter],
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.email_outlined,size: 16.0,color: Color(0x800F1424)),
          labelText: 'Email',
          errorText: snapshot.hasError ? snapshot.error.toString() : null),
      onChanged: block.changeEmail);
    }); 
  }

  _showPassword(BuildContext contexto){
  return StreamBuilder(
    stream: block.passwordStream, 
    builder: (BuildContext context, AsyncSnapshot snapshot){
      return TextFormField(
        style: Theme.of(context).textTheme.bodySmall,
        keyboardType: TextInputType.text,
        obscureText: true,
        cursorColor: const Color(0xff0f1424),
        inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.singleLineFormatter],
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.lock_outline,size: 18.0,color: Color(0x800F1424)),           
          labelText: 'Contraseña',
          counter: login ? TextButton(onPressed: ()=> _alertDialog("Contraseña"), 
            child: Text('Olvidé la contraseña!',style: Theme.of(contexto).textTheme.labelSmall)) : 
              Text(snapshot.data ?? '', style: Theme.of(contexto).textTheme.labelSmall),
          errorText: !login ? snapshot.hasError ? snapshot.error.toString() : null : null),
        onChanged: block.changePassword);
    });
  }

  _showName(){
  return StreamBuilder(
    key: ValueKey(login),
    stream: block.nameStream,
    builder: (BuildContext context, AsyncSnapshot snapshot){
      return TextFormField(
        style: Theme.of(context).textTheme.bodySmall,
        initialValue: snapshot.data,
        keyboardType: TextInputType.name,
        cursorColor: const Color(0xff0f1424),
        inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.singleLineFormatter],
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.person,size: 18.0,color: Color(0x800F1424)),  
          labelText: 'Nombre y Apellido',
          errorText: snapshot.hasError ? snapshot.error.toString() : null),
    onChanged: block.changeName);
    });
  }

  

  _buttonLogIn(){
    return StreamBuilder(
      stream: block.submitLogin, 
      builder: (_,snapshot){
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
          onPressed: snapshot.data == false || snapshot.data == null ? null : ()async{
            _updateLoading(true);

            final resp = await auth.signInWithEmail(block.email, block.password);
            
            if(resp == "LogIn") {
              _updateLoading(false);
              // ignore: use_build_context_synchronously
              Navigator.of(context).pushReplacementNamed("home");
            } else {
              _updateLoading(false);
              block.reset();
              final snackBar = SnackBar(content: Text(resp));
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).showSnackBar(snackBar);  
            }
          }, 
          child: const Text('Iniciar Sesión'))
        );
      }
    );
  }

  _buttonRegister(){
    return StreamBuilder(
      stream: block.submitRegister, 
      builder: (_,snapshot){
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
          onPressed: snapshot.data == false || snapshot.data == null ? null : () async {
            _updateLoading(true);
            final resp = await auth.registerUserWithEmailAndPassword(context);
            if(resp == "Registrado"){
              _updateLoading(false);
              block.reset();
              setState(() {
                login = true;
              });
              // ignore: use_build_context_synchronously
              Navigator.of(context).pushReplacementNamed("home");
            }
            else{
              _updateLoading(false);
            }
          }, 
          child: const Text('Registrarme'))
        );
      }
    );
  }

  _updateLoading(bool loading){
    setState(() {
      cargando = loading;
    });
  }

  void _alertDialog(String txt){
    showDialog(
      context: context, 
      builder: (_){
        return AlertDialog(
          actionsAlignment: MainAxisAlignment.spaceAround,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(child: Text(txt,style: Theme.of(context).textTheme.bodyMedium)),
              IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.close))
            ]
          ),
          content: const Text("content"),//_opcionesContent(context, txt),
          actions: [
            txt != "Cargar Foto" ?
            txt == "Términos y Condiciones" ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(onPressed: _opcionesActions(context,"Salir"), child: const Text("Cancelar")),
                ElevatedButton(onPressed: _opcionesActions(context,"Términos y Condiciones"), child: const Text("Aceptar"))
              ],
            )
            : SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _opcionesActions(context,txt),
                child: Text( txt != "Confirmación" ? "Enviar" : "Aceptar")
              )
            ) : const SizedBox(width: 0)
          ]
        );
      }
    );
  }
  _opcionesActions(BuildContext context,String txt) {
    switch (txt) {
      case "Contraseña":
        return ()async{
          final resp = await auth.resetPassword(block.email);
          if(resp == "Enviado"){
            // ignore: use_build_context_synchronously
            Navigator.of(context).pop();
          //services.showToast("Correo de recuperación enviado correctamente");
          }
          else{
            //services.showToast(resp);
          }
        };
      case "Términos y Condiciones":
        return () async {
          Navigator.of(context).pop();
         
        }; 
      default:
        return (){Navigator.of(context).pop();};
    }
  }
}