library morpheus_utils;

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../globals.dart';

// Calcola l'hwid dell'utente
Future<void> getHwid() async {
  Process process = await Process.start(
    Globals.javapathcontroller.text,
    ['-jar', '${LauncherUtils.getApplicationFolder("morpheus")}/Launcher.jar', '-h'],
  );

  await for (String line in process.stdout.transform(systemEncoding.decoder)) {
    if (line.contains("HWID:")) {
      Globals.hwid = line.trim().replaceAll(" ", "").split(":")[2];
    }
  }
  await process.exitCode;
}

// Prende le info del prodotto
Future<Map<String, dynamic>> prodinfo(var prodotto) async {
  final response = await http.post(
    Uri.parse('${Urls.morpheusApiURL}/appinfo'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'accessToken': Globals.morpheusAuthResponse["data"]["accessToken"],
      'productID': prodotto,
    }),
  );

  return jsonDecode(response.body);
}

// Lista di prodotti da mostrare agli user non registrati
Future<void> getAllProducts() async {
  final response = await http.get(Uri.parse('${Urls.morpheusApiURL}/applist'));

  Globals.morpheusProductsResponse = json.decode(response.body);

  Globals.prodottoList.clear();
  for (var product in Globals.morpheusProductsResponse['data']) {
    Globals.prodottoList.add({
      'name': product['name'],
      'version': product['version'],
      'gameversion': product['gameversion'],
      'description': product['description'],
      'image': product['image'],
      'link': product['link'],
    });
  }
}
