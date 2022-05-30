import 'package:flutter/material.dart';

import 'features/authentication/login/view/login_page.dart';

void main() {
  runApp(PandaTechNFCApp());
}

class PandaTechNFCApp extends StatelessWidget {
  const PandaTechNFCApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      title: 'PandaTechNFC',
      home: LoginPage(),
    );
  }
}
