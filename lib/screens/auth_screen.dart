import 'package:chat/models/auth_data.dart';
import 'package:chat/widgets/auth_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isLoading = false;

  Future<void> _handleSubmit(AuthData authData) async {
    setState(() {
      _isLoading = true;
    });

    UserCredential authResult;
    try {
      if (authData.isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
          email: authData.email.trim(),
          password: authData.password,
        );
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
          email: authData.email.trim(),
          password: authData.password,
        );

        final ref = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child(authResult.user.uid + '.jpg');

        await ref.putFile(authData.image).onComplete;
        final url = await ref.getDownloadURL();

        final userData = {
          'name': authData.name,
          'email': authData.email,
          'imageUrl': url,
        };

        await FirebaseFirestore.instance
            .collection('users')
            .doc(authResult.user.uid)
            .set(userData);
      }
    } on PlatformException catch (err) {
      final msg = err.message ?? 'Ocorreu um erro! Verifique suas credenciais!';
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(msg),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    } catch (err) {
      print(err);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  AuthForm(_handleSubmit),
                  if (_isLoading)
                    Positioned.fill(
                      child: Container(
                        margin: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(0, 0, 0, 50.0),
                        ),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
