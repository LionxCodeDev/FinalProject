import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lionxcode_finalproject/firebase/firestore.dart';
import 'package:lionxcode_finalproject/providers/login_block.dart';
import 'package:lionxcode_finalproject/providers/provider.dart';
import 'package:lionxcode_finalproject/services/shared_preferences.dart';

class AuthFirebase{

  final FirebaseAuth _auth = FirebaseAuth.instance;
  late LoginBlock block;
  final preferencias = PreferenciasUsuario();
  static String uid = 'none';

  Future<String> signInWithEmail(String email, String password)async{
    try{
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password); 
      uid = userCredential.user!.uid;
      final data = await Firestore(collection: "Usuarios").getDataUser(uid);
      _actualizarGetDataUser(data);
      return "LogIn";
    
    } on FirebaseAuthException catch (e){
       
      if (e.code == 'user-not-found') {
        return 'Ese correo no se encuentra registrado';
      }

      if (e.code == 'wrong-password') {
        return 'La contraseña es incorrecta';
      }

      if (e.code == 'invalid-email') {
        return 'Correo no válido';
      }

      if (e.code == 'invalid-credential'){
        return 'Correo o contraseña son incorrectos';
      }

      return 'Ocurrió un error, inténtelo mas tarde';

    } catch (e){
      return 'Ocurrió un error, inténtelo mas tarde';
    }
  }

  Future<String> registerUserWithEmailAndPassword(BuildContext context) async {
    block = Provide.of(context); 
    try{
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: block.email, 
        password: block.password
      );
      uid = userCredential.user!.uid;
      final registro = await Firestore(collection: "Usuarios").crearNuevoUsuario(block, uid);
      
      if(registro){
        
        final Map<String, dynamic> dataRegister = {
        'nombre': block.name,
        'email': block.email,
        };
        _actualizarGetDataUser(dataRegister);
        return "Registrado";
      }
      else{
        return "Ocurrió un error, inténtelo mas tarde";
      }

    } on FirebaseAuthException catch(e){
      if (e.code == 'email-already-in-use') {
        return "Ese correo ya se encuentra registrado";
      }
      else{
        return "Ocurrió un error, inténtelo mas tarde";
      }
    } catch(e){
      return "Ocurrió un error, inténtelo mas tarde";
    }
  }

  Future<String> resetPassword(String email)async{
    try{
      _auth.sendPasswordResetEmail(email: email);
      return "Enviado";
    } on FirebaseAuthException catch (e){
      if(e.code == 'user-not-found'){
        return "Ese correo no se encuentra registrado";
      }
      return "Ocurrió un error, inténtelo mas tarde";
    } catch (e){
      return "Ocurrió un error, inténtelo mas tarde";
    }
  }

  Future<bool> logOut() async {
    try{
      await _auth.signOut();
      _updatePreferencias('none');
      return true;
    }catch(e){
      return false;
    }
  }

  _actualizarGetDataUser(dynamic data){
    preferencias.updateUid(uid);
    preferencias.updateName(data['nombre']);
    preferencias.updateEmail(data['email']);
  }

  _updatePreferencias(String none){
    preferencias.updateUid(none);
    preferencias.updateName(none);
    preferencias.updateEmail(none);
  }
}