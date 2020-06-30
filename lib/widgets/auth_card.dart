import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/exceptions/auth_exception.dart';
import 'package:shopping_app/providers/auth.dart';

enum AuthMode {
  Signup,
  Login,
}

class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  AuthMode _authMode = AuthMode.Login;

  final _form = GlobalKey<FormState>();

  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  bool _isLoading = false;

  final _passowrdController = TextEditingController();

  void _showDialogError(String msg) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Ocorreu um erro'),
          content: Text(msg),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Ok"),
            )
          ],
        );
      },
    );
  }

  Future<void> _submit() async {
    _form.currentState.save();
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    setState(() {
      _isLoading = true;
    });

    final auth = Provider.of<Auth>(context, listen: false);

    try {
      if (_authMode == AuthMode.Login) {
        await auth.signin(_authData['email'], _authData['password'].toString());
      } else {
        await auth.signup(_authData['email'], _authData['password'].toString());
      }
    } on AuthException catch (e) {
      _showDialogError(e.toString());
    } catch (e) {
      print(e);
      _showDialogError('Erro desconhecido');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 8.0,
      child: Container(
        padding: EdgeInsets.all(16),
        alignment: Alignment.center,
        width: deviceSize.width * 0.75,
        height: _authMode == AuthMode.Login ? 290 : 380,
        child: Form(
          key: _form,
          child: Column(
            children: <Widget>[
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'E-mail',
                ),
                validator: (value) {
                  if (value.isEmpty || !value.contains('@')) {
                    return "Informe um e-mail válido!";
                  }

                  return null;
                },
                onSaved: (value) => _authData['email'] = value,
              ),
              TextFormField(
                controller: _passowrdController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Senha',
                ),
                validator: (value) {
                  if (value.isEmpty || value.length < 5) {
                    return "Informe uma senha válida!";
                  }

                  return null;
                },
                onSaved: (value) {
                  _authData['password'] = value.toString();
                },
              ),
              if (_authMode == AuthMode.Signup)
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Confirmar Senha',
                  ),
                  validator: _authMode == AuthMode.Signup
                      ? (value) {
                          if (value.toString() != _passowrdController.text) {
                            return "As senhas devem ser iguais!";
                          }

                          return null;
                        }
                      : null,
                ),
              Spacer(),
              if (_isLoading)
                CircularProgressIndicator()
              else
                RaisedButton(
                  child: Text(
                    _authMode == AuthMode.Login ? 'Entrar' : 'Registar',
                  ),
                  onPressed: _submit,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  color: Theme.of(context).primaryColor,
                  textColor: Theme.of(context).primaryTextTheme.headline6.color,
                  padding: EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 8,
                  ),
                ),
              FlatButton(
                textColor: Theme.of(context).primaryColor,
                child:
                    Text(_authMode == AuthMode.Login ? 'Cadastrar' : "Login"),
                onPressed: () {
                  setState(() {
                    _authMode = _authMode == AuthMode.Login
                        ? AuthMode.Signup
                        : AuthMode.Login;
                  });
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
