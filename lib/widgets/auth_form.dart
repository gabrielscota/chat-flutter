import 'dart:io';

import 'package:chat/models/auth_data.dart';
import 'package:chat/widgets/user_image_picker.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final void Function(AuthData authData) onSubmit;

  AuthForm(this.onSubmit);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthData _authData = AuthData();

  _submit() {
    bool isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (_authData.image == null && _authData.isSignup) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Precisamos da sua foto!'),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }

    if (isValid) {
      widget.onSubmit(_authData);
    }
  }

  void _handlePickedImage(File image) {
    _authData.image = image;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  if (_authData.isSignup) UserImagePicker(_handlePickedImage),
                  if (_authData.isSignup)
                    TextFormField(
                      autocorrect: true,
                      textCapitalization: TextCapitalization.words,
                      enableSuggestions: false,
                      key: ValueKey('name'),
                      decoration: InputDecoration(
                        labelText: 'Nome',
                      ),
                      initialValue: _authData.name,
                      onChanged: (value) => _authData.name = value,
                      validator: (value) {
                        if (value == null || value.trim().length < 4) {
                          return 'Nome deve ter no mínimo 4 caracteres.';
                        }
                        return null;
                      },
                    ),
                  TextFormField(
                    autocorrect: false,
                    textCapitalization: TextCapitalization.none,
                    enableSuggestions: false,
                    key: ValueKey('email'),
                    decoration: InputDecoration(
                      labelText: 'Email',
                    ),
                    onChanged: (value) => _authData.email = value,
                    validator: (value) {
                      if (value == null || !value.contains('@')) {
                        return 'Informe um email válido.';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    key: ValueKey('password'),
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Senha',
                    ),
                    onChanged: (value) => _authData.password = value,
                    validator: (value) {
                      if (value == null || value.trim().length < 7) {
                        return 'Senha deve ter no mínimo 7 caracteres';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 12),
                  RaisedButton(
                    onPressed: _submit,
                    child: Text(_authData.isLogin ? 'Entrar' : 'Cadastrar'),
                  ),
                  FlatButton(
                    onPressed: () {
                      setState(() {
                        _authData.toggleMode();
                      });
                    },
                    child: Text(_authData.isLogin
                        ? 'Criar uma nova conta?'
                        : 'Já possui uma conta?'),
                    textColor: Theme.of(context).primaryColor,
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
