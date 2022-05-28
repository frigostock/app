import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:frigostock/auth.dart';
// ignore: unused_import
import "register.dart" show Register;

class Register extends StatefulWidget {
  const Register({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final auth = BaseAuth();

//dispose is a function that runs when the widget is removed from the widget tree
  @override
  void dispose() {
    nameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void submit() {
    // check if all controller are valid
    if (_formKey.currentState!.validate()) {
      auth
          .signUp(nameController.text, passwordController.text)
          .then((value) => {Navigator.pop(context)},
              onError: (e) => {
                    showDialog(
                        context: context,
                        builder: (context) {
                          final dialogContext = context;
                          return AlertDialog(
                            title: const Text("Erreur"),
                            content: const Text(
                                "Une erreur est survenue ou votre compte existe déjà"),
                            actions: <Widget>[
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(dialogContext);
                                  },
                                  child: const Text("OK"))
                            ],
                          );
                        })
                  });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                        controller: nameController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                            labelText: 'Email', prefixIcon: Icon(Icons.email)),
                        validator: (value) {
                          // check if value is empty
                          if (value!.isEmpty) {
                            return 'Veuillez entrer une adresse mail';
                          } else {
                            // check if the email is valid
                            if (!EmailValidator.validate(value)) {
                              return "Veuillez entrer une adresse mail valide";
                            }
                          }

                          return null;
                        })),
                Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                        controller: passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: const InputDecoration(
                          labelText: 'mot de passe',
                          prefixIcon: Icon(Icons.password_sharp),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Veuillez entrer un mot de passe valide';
                          }
                          return null;
                        })),
                ElevatedButton(
                    onPressed: () => submit(),
                    child: const Text("S'enregistrer"))
              ],
            )),
      ),
    );
  }
}
