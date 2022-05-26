import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:panda_tech_nfc/features/dashboard/screens/dashboard_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  String? _email;
  String? _password;
  bool _showPassword = false;

  bool _validateForm() {
    final form = formKey.currentState;

    if (form != null && form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future _loginCommand() async {
    if (_validateForm()) {
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DashboardPage(email: _email!)),
      );

      // _email = null;
      // _password = null;
      //
      // setState(() {
      //   _email = null;
      //   _password = null;
      // });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('lib/assets/images/animated_background.gif'),
                fit: BoxFit.cover)),
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Form(
            key: formKey,
            child: Container(
              height: 350,
              padding: const EdgeInsets.all(16.0),
              decoration: new BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // CircleAvatar(
                  //   radius: 150,
                  //   backgroundImage: NetworkImage(
                  //       'https://cdn.vox-cdn.com/thumbor/M-JI6uZz5smov6Qq_vNarBXtKkU=/155x65:995x648/1200x800/filters:focal(489x354:677x542)/cdn.vox-cdn.com/uploads/chorus_image/image/70264946/bored_ape_nft_accidental_.0.jpg'),
                  // ),
                  Text('Welcome to Weather App',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Email'),
                    validator: (val) => val!.length < 1
                        ? 'Please provide a valid email.'
                        : null,
                    onSaved: (val) => _email = val,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.remove_red_eye,
                          color: this._showPassword ? Colors.blue : Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            this._showPassword = !this._showPassword;
                          });
                        },
                      ),
                    ),
                    validator: (val) => val!.length < 8
                        ? 'Your password is too Password too short..'
                        : null,
                    onSaved: (val) => _password = val,
                    obscureText: !this._showPassword,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                  ),
                  Container(
                    width: double.infinity,
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _loginCommand();
                        });
                      },
                      child: Text('Login'),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
