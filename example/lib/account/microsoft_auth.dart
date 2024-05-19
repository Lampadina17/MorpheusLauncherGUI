library msauth;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:encrypt/encrypt.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:morpheus_launcher_gui/globals.dart';

final client_id = decrypt('xPeIONFluJktnyRqRW2qzlGSocmqb0z4ge9Uo1AF980q5FQNbG8hgtylIv24tgeP', 'FPzGDUVvU4L?*;j+x`XrGZUQJ)rr/M&#');

String decrypt(String ciphertext, String keytext) {
  final key = Key.fromUtf8(keytext);
  final iv = IV.fromLength(16);

  return Encrypter(AES(key)).decrypt64(
    ciphertext,
    iv: iv,
  );
}

Future<String> doMicrosoftConsent(dynamic context) async {
  var response = await http.post(
    Uri.parse("${Urls.msAuthURL}/devicecode"),
    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
    body: {
      'client_id': client_id,
      'scope': 'XboxLive.signin offline_access',
    },
  );

  if (response.statusCode == 200) {
    return response.body;
  }

  return '[MS]: ${AppLocalizations.of(context)!.account_post_fail}: ${response.statusCode}';
}

Future<dynamic> doMicrosoftRefresh(dynamic context, String refresh_token) async {
  var data = await getToken(context, 'refresh_token', refresh_token, null);
  if (data != null) {
    return doXboxLiveAuth(context, data['access_token']);
  }

  return data;
}

Future getToken(dynamic context, String grantType, var refreshToken, var deviceCode) async {
  var body;
  if (grantType == 'refresh_token') {
    body = {
      'grant_type': grantType,
      'client_id': client_id,
      'refresh_token': refreshToken,
      'scope': 'XboxLive.signin offline_access',
    };
  } else {
    body = {
      'grant_type': grantType,
      'client_id': client_id,
      'device_code': deviceCode,
    };
  }
  var response = await http.post(
    Uri.parse('${Urls.msAuthURL}/token'),
    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
    body: body,
  );

  final data = json.decode(response.body);
  if (response.statusCode == 200) {
    return data;
  }

  return '[MS]: ${AppLocalizations.of(context)!.account_post_fail}: ${response.statusCode} ${data}';
}

Future<dynamic> doXboxLiveAuth(dynamic context, String token) async {
  final url = Uri.parse(Urls.xboxAuthURL);
  final headers = {'Content-Type': 'application/json'};
  final body = jsonEncode({
    'Properties': {
      'AuthMethod': 'RPS',
      'SiteName': 'user.auth.xboxlive.com',
      'RpsTicket': 'd=$token',
    },
    'RelyingParty': 'http://auth.xboxlive.com',
    'TokenType': 'JWT',
  });

  final response = await http.post(url, headers: headers, body: body);
  final data = json.decode(response.body);

  if (response.statusCode == 200) {
    return await doXSTS(context, data['Token']);
  }

  return '[XBL]: ${AppLocalizations.of(context)!.account_post_fail}: ${response.statusCode} ${data}';
}

Future<dynamic> doXSTS(dynamic context, String token) async {
  final url = Uri.parse(Urls.xstsAuthURL);
  final headers = {'Content-Type': 'application/json'};
  final body = jsonEncode({
    'Properties': {
      'SandboxId': 'RETAIL',
      'UserTokens': [token],
    },
    'RelyingParty': 'rp://api.minecraftservices.com/',
    'TokenType': 'JWT',
  });

  final response = await http.post(url, headers: headers, body: body);
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final uhs = data['DisplayClaims']['xui'][0]['uhs'];
    final authToken = data['Token'];

    var output = await doMCAuth(context, uhs, authToken);

    return output;
  } else if (response.statusCode == 401) {
    final data = json.decode(response.body);
    final xerr = data['XErr'];
    switch (xerr) {
      case 2148916233:
        return AppLocalizations.of(context)!.account_xsts_2148916233_fail;
      case 2148916235:
        return AppLocalizations.of(context)!.account_xsts_2148916235_fail;
      case 2148916236:
      case 2148916237:
        return AppLocalizations.of(context)!.account_xsts_2148916237_fail;
      case 2148916238:
        return "${AppLocalizations.of(context)!.account_xsts_2148916238_fail} ${data['Redirect']}";
      default:
        return "${AppLocalizations.of(context)!.generic_error_msg}: ${xerr}";
    }
  }

  return "[XSTS]: ${AppLocalizations.of(context)!.account_post_fail}: ${response.statusCode} ${response.body}";
}

Future<dynamic> doMCAuth(dynamic context, String hash, String token) async {
  final url = Uri.parse(Urls.mcAuthURL);
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'identityToken': 'XBL3.0 x=$hash;$token'}),
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);

    return data;
  }

  return "[MC]: ${AppLocalizations.of(context)!.account_post_fail}: ${response.statusCode} ${response.body}";
}

Future<dynamic> fetchMinecraftProfile(dynamic context, String token) async {
  final url = Uri.https("api.minecraftservices.com", "/minecraft/profile");
  final response = await http.get(url, headers: {'Authorization': 'Bearer $token'});
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);

    return data;
  }

  return "[MC]: ${AppLocalizations.of(context)!.account_get_fail}: ${response.statusCode} ${json.decode(response.body)}";
}

Future<String> uploadSkin(dynamic context, String variant, dynamic token, String filePath) async {
  final url = Uri.parse(Urls.mcSkinURL);
  final request = http.MultipartRequest('POST', url);

  request.headers['Authorization'] = 'Bearer $token';

  // Add variant parameter to the request
  request.fields['variant'] = variant;

  // Create a file stream and add it to the request as a MultipartFile
  final file = File(filePath);
  if (!file.existsSync()) {
    throw Exception("${AppLocalizations.of(context)!.account_skin_file_fail} $filePath");
  }

  final stream = http.ByteStream(file.openRead());
  final length = await file.length();
  final multipartFile = http.MultipartFile('file', stream, length, filename: filePath.split("/").last, contentType: MediaType('image', 'png'));

  // Add the file to the request
  request.files.add(multipartFile);

  // Send the request and get the response
  final response = await request.send();

  if (response.statusCode == 200) {
    return AppLocalizations.of(context)!.account_skin_success;
  } else {
    return "[MC]: ${AppLocalizations.of(context)!.account_post_fail}: ${response.statusCode} ${response.reasonPhrase}";
  }
}
