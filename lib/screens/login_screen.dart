import 'package:flutter/material.dart';
import 'package:my_workout/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static const String route = '/login';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final _user = {
    'email': '',
    'password': '',
    'confirmPassword': '',
  };
  final _formKey = GlobalKey<FormState>();
  final _passwordFocus = FocusNode();
  final _confirmPasswordFocus = FocusNode();
  bool _loading = false;
  bool _login = true;
  AnimationController _controller;
  Animation<Size> _heightAnimation;

  void _save() async {
    bool valid = _formKey.currentState.validate();

    if (valid) {
      setState(() {
        _loading = true;
      });
      try {
        _formKey.currentState.save();

        if (_login) {
          await Provider.of<AuthProvider>(context, listen: false).manageAuth(
            _user['email'],
            _user['password'],
            'signInWithPassword',
          );
        } else {
          if (_user['password'] == _user['confirmPassword']) {
            await Provider.of<AuthProvider>(context, listen: false).manageAuth(
              _user['email'],
              _user['password'],
              'signUp',
            );

            _formKey.currentState.reset();
            _showAlert('Sucesso', 'Usuário cadastrado, você já pode entrar no sistema!');
            _switchMode();
          } else {
            _showAlert('Formulário inválido', 'As senhas devem ser iguais!');
          }
        }
      } catch (e) {
        _showAlert('Não foi possível completar a operação', e.message);
      } finally {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  void _showAlert(String title, String content) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
        );
      },
    );
  }

  void _switchMode() {
    if (_login) {
      _controller.forward();
    } else {
      _controller.reverse();
    }

    setState(() {
      _login = !_login;
    });
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 500,
      ),
    );

    _heightAnimation = Tween<Size>(
      begin: Size(double.infinity, 200),
      end: Size(double.infinity, 0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.linear,
      ),
    );

    // _heightAnimation.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg1.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                AnimatedBuilder(
                  animation: _heightAnimation,
                  builder: (ctx, ch) {
                    return SizedBox(
                      height: _heightAnimation.value.height,
                      child: ch,
                    );
                  },
                  child: Text(
                    'MyWorkout',
                    style: TextStyle(
                      fontSize: 65,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                  ),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_passwordFocus),
                  validator: (value) {
                    if (value.length < 4) {
                      return 'Insira um email válido';
                    }
                    return null;
                  },
                  onSaved: (value) => _user['email'] = value,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Senha',
                  ),
                  focusNode: _passwordFocus,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_confirmPasswordFocus),
                  validator: (value) {
                    if (value.length < 6) {
                      return 'A senha deve conter no minimo 6 caracteres';
                    }
                    return null;
                  },
                  obscureText: true,
                  onSaved: (value) => _user['password'] = value,
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  height: _login ? 0 : 60,
                  child: AnimatedOpacity(
                    opacity: _login ? 0 : 1,
                    duration: Duration(milliseconds: 500),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Confirmar Senha',
                      ),
                      focusNode: _confirmPasswordFocus,
                      validator: (value) {
                        if (value.length < 6 && !_login) {
                          return 'A senha deve conter no minimo 6 caracteres';
                        }
                        return null;
                      },
                      obscureText: true,
                      onSaved: (value) => _user['confirmPassword'] = value,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                if (!_loading)
                  SizedBox(
                    height: 50,
                    child: RaisedButton(
                      onPressed: _save,
                      child: Text(
                        _login ? 'ENTRAR' : 'CADASTRAR',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                if (!_loading)
                  FlatButton(
                    onPressed: _switchMode,
                    child: Text(
                      _login ? 'Não tenho uma conta' : 'Já possuo uma conta, entrar',
                      style: TextStyle(color: Theme.of(context).accentColor),
                    ),
                  ),
                if (_loading)
                  Center(
                    child: CircularProgressIndicator(),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
