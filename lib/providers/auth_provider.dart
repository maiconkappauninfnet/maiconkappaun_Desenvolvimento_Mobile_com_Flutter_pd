import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthProvider with ChangeNotifier {

  String? message;
  String? token;

  final _url = "https://identitytoolkit.googleapis.com";
  final _resource = "/v1/accounts";
  final _apiKey = "AIzaSyAHmqHNQ2dTfiY2SGdJhrwPm5FXc_V4Rm8";

  Future<bool> signUp(String email, String password) async {
    String sUri = '$_url$_resource:signUp?key=$_apiKey';
    Uri uri = Uri.parse(sUri);

    var response = await http.post(uri, body: {
      'email': email,
      'password': password,
      'returnSecureToken': 'true'
    });

    if (response.statusCode == 200) {
      message = "Usuário cadastrado com sucesso.";
      var body = jsonDecode(response.body);
      token = body['idToken'];
      return true;
    } else {
      message = "Erro ao cadastrar Usuário.";
      return false;
    }

  }

  Future<bool> signIn(String email, String password) async {
    String sUri = '$_url$_resource:signInWithPassword?key=$_apiKey';
    Uri uri = Uri.parse(sUri);

    var response = await http.post(uri, body: {
      'email': email,
      'password': password,
      'returnSecureToken': 'true'
    });

    if (response.statusCode == 200) {
      message = "Usuário autenticado com sucesso.";
      var body = jsonDecode(response.body);
      token = body['idToken'];
      return true;
    } else {
      message = 'Falha ao autenticar o Usuário.';
      return false;
    }
  }

}