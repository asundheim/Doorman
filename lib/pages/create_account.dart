import 'package:flutter/material.dart';
import 'package:validators/validators.dart';
import './tandc.dart';

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  Icon _emailValid = Icon(Icons.clear, color: Colors.red[300]);
  Icon _passwordValid = Icon(Icons.clear, color: Colors.red[300]);
  Icon _confirmPasswordValid = Icon(Icons.clear, color: Colors.red[300]);
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  _CreateAccountState() {
    _emailController.addListener(_emailListener);
    _passwordController.addListener(_passwordListener);
    _confirmPasswordController.addListener(_confirmPasswordListener);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        autovalidate: true,
        child: Center(
          child: ListView(
            padding: const EdgeInsets.all(20.0),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(60.0),
                child: Center(
                  child: Text(
                    'Create Account',
                    style: Theme.of(context).textTheme.display1,
                  ),
                )
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    icon: const Icon(Icons.person, color: Colors.grey),
                    suffixIcon: _emailValid,
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: _emailValid.color)
                    ),
                    errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red[300])
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red[300])
                    ),
                  ),
                  validator: _validateEmail,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    icon: const Icon(Icons.vpn_key, color: Colors.grey),
                    suffixIcon: _passwordValid,
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: _passwordValid.color)
                    ),
                    errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red[300])
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red[300])
                    ),
                  ),
                  obscureText: true,
                  validator: _validatePassword,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextFormField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(
                    icon: const Icon(Icons.vpn_key, color: Colors.grey),
                    suffixIcon: _confirmPasswordValid,
                    labelText: 'Confirm Password',
                    labelStyle: TextStyle(color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: _confirmPasswordValid.color)
                    ),
                    errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red[300])
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red[300])
                    ),
                  ),
                  obscureText: true,
                  validator: _validateConfirmPassword,
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 24.0, bottom: 12.0),
                  child: Center(
                    child: RaisedButton(
                      child: const Text('Create Account'),
                      color: Colors.deepPurple[300],
                      onPressed: () {
                        _createAccount();
                      },
                    ),
                  )
              ),
            ],
          ),
        ),
      )
    );
  }

  String _validateEmail(String email) {
    if (!isEmail(email)) {
      return 'Invalid Email';
    }
  }

  String _validatePassword(String password) {
    if (password.length < 6) {
      return 'Password must be 6 characters or more';
    }
  }

  String _validateConfirmPassword(String password) {
    if (password != _passwordController.text) {
      return 'Password must match';
    }
  }

  void _emailListener() {
    if (!isEmail(_emailController.text)) {
      setState(() => _emailValid = Icon(Icons.clear, color: Colors.red[300]));
    } else {
      setState(() => _emailValid = Icon(Icons.check, color: Colors.green[300]));
    }
  }

  void _passwordListener() {
    if (_passwordController.text.length < 6) {
      setState(() => _passwordValid = Icon(Icons.clear, color: Colors.red[300]));
    } else {
      setState(() => _passwordValid = Icon(Icons.check, color: Colors.green[300]));
    }
  }

  void _confirmPasswordListener() {
    if (_confirmPasswordController.text != _passwordController.text) {
      setState(() => _confirmPasswordValid = Icon(Icons.clear, color: Colors.red[300]));
    } else {
      setState(() => _confirmPasswordValid = Icon(Icons.check, color: Colors.green[300]));
    }
  }

  void _createAccount() async {
    if (_formKey.currentState.validate()) {
      Navigator.push(
          context, MaterialPageRoute<TermsAndConditions>(
          builder: (BuildContext context) => TermsAndConditions(email: _emailController.text, password: _passwordController.text))
      );
    } else {
      showDialog<AlertDialog>(
          context: context,
          builder: (BuildContext context) =>
            AlertDialog(
              actions: <Widget>[
                RaisedButton(
                  child: const Text('Ok'),
                  onPressed: () => Navigator.of(context).pop(),
                )
              ],
              content: const Text('Please fix errors before submitting')
            )
      );
    }
  }
}
