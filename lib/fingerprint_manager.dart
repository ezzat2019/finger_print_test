import 'package:finger_print_test/home_sc.dart';
import 'package:finger_print_test/login_sc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

class FingerPrintManager {
  final LocalAuthentication auth = LocalAuthentication();
  late FlutterSecureStorage secureStorage;


  logout(BuildContext context)
 async {
    await secureStorage.delete(key: SecureStorgeKeys.EMAIL_KEY);
    await secureStorage.delete(key: SecureStorgeKeys.PASSWORD_KEY);
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginSc(),));
  }
  Future<bool> canUseFingerPrint()async{
    String? storedEmail=   await secureStorage.read(key: SecureStorgeKeys.EMAIL_KEY);
    String? storedPass=   await secureStorage.read(key: SecureStorgeKeys.PASSWORD_KEY);
    if(storedEmail==null||storedPass==null){
      return false;
    }
    if(storedEmail.isEmpty||storedPass.isEmpty)
    {
      return false;
    }
    final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
    bool canAuthenticate =
        canAuthenticateWithBiometrics || await auth.isDeviceSupported();
    final List<BiometricType> availableBiometrics =
    await auth.getAvailableBiometrics();

    if (availableBiometrics.isEmpty) {
      canAuthenticate=false;
    }

    return canAuthenticate;
  }
  
   Future<bool> _authByFingerPrint()
  async{
    bool canUseFinger=await canUseFingerPrint();
    if(canUseFinger)
      {
        final bool didAuthenticate = await auth.authenticate(
            localizedReason: 'Please authenticate to goto home',
            options: const AuthenticationOptions(biometricOnly: true));
        return didAuthenticate;
      }else
        {
          return false;
        }

  }
  FingerPrintManager() {
    AndroidOptions _getAndroidOptions() => const AndroidOptions(
          encryptedSharedPreferences: true,
        );
    secureStorage = FlutterSecureStorage(aOptions: _getAndroidOptions());
  }
  
  _saveLoginWithFingerPrint(String email,String pass)
  async{
    await secureStorage.write(key: SecureStorgeKeys.EMAIL_KEY, value: email);
    await secureStorage.write(key: SecureStorgeKeys.PASSWORD_KEY, value:pass );
  }
  
  Future login(BuildContext context,String email,String pass,bool replace)
  async{
    
    if(replace)
      {
        _manualLogin(email, pass, context);
        return;
      }
    
    String? storedEmail=   await secureStorage.read(key: SecureStorgeKeys.EMAIL_KEY);
    String? storedPass=   await secureStorage.read(key: SecureStorgeKeys.PASSWORD_KEY);
    
    if(storedEmail!=null&&storedPass!=null){
      if(storedEmail.isEmpty||storedPass.isEmpty)
      {
        _manualLogin(email, pass, context);
      }
      else
      {
        await _loginByFinger(context, storedEmail, storedPass);
      }
    }else
      {
        _manualLogin(email, pass, context);
      }


  }

  void _manualLogin(String email, String pass, BuildContext context) {
    _saveLoginWithFingerPrint(email, pass);
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeSc(email: email,
    pass: pass,
    type: LoginTypes.MANUAL,),));
  }

  Future<void> _loginByFinger(BuildContext context, String storedEmail, String storedPass) async {
      bool authFinger=await _authByFingerPrint();
    if(authFinger)
      {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeSc(email: storedEmail,
          pass: storedPass,
          type: LoginTypes.BY_FINGERPRINT,),));
      }
  }
  
}
abstract class SecureStorgeKeys{
  static final String EMAIL_KEY="email";
  static final String PASSWORD_KEY="pass";
}
abstract class LoginTypes{
  static final String MANUAL="manual login";
  static final String BY_FINGERPRINT="login by fingerprint";
} 
