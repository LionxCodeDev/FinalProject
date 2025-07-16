import 'package:shared_preferences/shared_preferences.dart';

class PreferenciasUsuario {
  static late SharedPreferences prefs;

  static Future<void> configurePrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  get getUid {
    return prefs.getString("uid");
  }

  get getName {
    return prefs.getString("name");
  }

  get getEmail {
    return prefs.getString("email");
  }
  
  ///////////////////////////// SET ////////////////

  updateUid(String uid) {
    prefs.setString("uid", uid);
  }

  updateName(String name) {
    prefs.setString("name", name);
  }

  updateEmail(String email) {
    prefs.setString("email", email);
  }
}
