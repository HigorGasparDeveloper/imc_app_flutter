// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'dart:math';

class Formulario extends StatefulWidget {
  const Formulario({Key? key}) : super(key: key);

  @override
  State<Formulario> createState() => _FormularioState();
}

class _FormularioState extends State<Formulario> {
  late final TextEditingController _peso_controller, _altura_controller;
  late FocusNode _focusNodeAltura;
  double peso = 0, altura = 0;
  void execStateSuccessful(BuildContext context) {
    _peso_controller.clear();
    _altura_controller.clear();
    Navigator.pop(context, 'OK');
    _focusNodeAltura.requestFocus();
  }

  @override
  void initState() {
    super.initState();
    _peso_controller = TextEditingController();
    _altura_controller = TextEditingController();
    _focusNodeAltura = FocusNode();
  }

  @override
  void dispose() {
    _peso_controller.dispose();
    _altura_controller.dispose();
    _focusNodeAltura.dispose();
    super.dispose();
  }

  String returnDiagnostic() {
    String diagnostico = "Obesidade III";
    double imc = getImc();
    Map<double, String> diagnosticos = {
      18.5:"Abaixo do peso",
      24.9:"Peso normal",
      29.9:"Sobrepeso",
      34.9:"Obesidade I",
      39.9:"Obesidade II"
    };

    for(var rec in diagnosticos.entries){
      var recImc = rec.key;
      var recRec = rec.value;
      if(imc < recImc){
        diagnostico = recRec;
        break;
      }
    }

    return diagnostico;
  }

  double getImc() {
    return double.parse((peso / pow(altura, 2)).toStringAsFixed(2));
  }

  void verificaResultado() {
    Map<String, double> resultado = calcular();
    String diagnostico = returnDiagnostic();
    String mensagem = "";
    String titulo = "";
    if (resultado['Status'] == 200) {
      var imc = resultado['imc'];
      mensagem = "Seu IMC é de: $imc \nDiagnóstico: $diagnostico";
      titulo = "Sucesso!";
    } else {
      mensagem = "Preencha todos os campos para calcular o seu IMC";
      titulo = "Alerta!";
    }
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(titulo),
        content: Text(mensagem),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => {
              (resultado['Status'] == 200)
                  ? execStateSuccessful(context)
                  : Navigator.pop(context, 'OK')
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Map<String, double> calcular() {
    if (_peso_controller.text != "" && _altura_controller.text != "") {
      peso =
          double.tryParse((_peso_controller.text).replaceAll(',', '.'))!;
      altura =
          double.tryParse((_altura_controller.text).replaceAll(',', '.'))!;
      double imc = getImc();
      return {"Status": 200, "imc": imc};
    } else {
      return {"Status": 400};
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unnecessary_new
    return new Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Column(
        children: [
          TextField(
            obscureText: false,
            focusNode: _focusNodeAltura,
            // onChanged: (value) => altura = value as double,
            controller: _altura_controller,
            onSubmitted: (String value) async {
              await showDialog<void>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Thanks!'),
                    content: Text(
                        'You typed "$value", which has length ${value.characters.length}.'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  );
                },
              );
            },
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: "Altura"),
          ),
          TextField(
            obscureText: false,
            // onChanged: (value) => peso = value as double,
            controller: _peso_controller,
            onSubmitted: (String value) async {
              await showDialog<void>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Thanks!'),
                    content: Text(
                        'You typed "$value", which has length ${value.characters.length}.'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  );
                },
              );
            },
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: "Peso"),
          ),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: RaisedButton(
              textColor: Colors.white,
              color: Colors.orange,
              onPressed: () => verificaResultado(),
              child: const Text("Calcular"),
            ),
          )
        ],
      ),
    );
  }
}
