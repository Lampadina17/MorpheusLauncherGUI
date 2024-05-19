import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:morpheus_launcher_gui/globals.dart';
import 'package:morpheus_launcher_gui/main.dart';
import 'package:morpheus_launcher_gui/views/main_page.dart';

import 'pwdreset_page.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback _handleLogin;
  final VoidCallback _handleRegister;
  final VoidCallback _handleReset;

  const LoginPage({Key? key, required void Function() handlelogin, required void Function() handleregister, required void Function() handlereset})
      : _handleLogin = handlelogin,
        _handleRegister = handleregister,
        _handleReset = handlereset,
        super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorUtils.dynamicWindowBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                drawTitleCustomBar(),
              ],
            ),
            Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    /** Label */
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Material(
                        elevation: 15,
                        color: Colors.transparent,
                        shadowColor: ColorUtils.defaultShadowColor,
                        borderRadius: BorderRadius.circular(100),
                        child: Text(
                          "Morpheus Account",
                          style: TextStyle(
                            color: ColorUtils.primaryFontColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            fontFamily: 'Comfortaa',
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),

                    /** Campo username */
                    LoginWidgetUtils.buildTextField(
                        context, AppLocalizations.of(context)!.username_label, Globals.usercontroller, false, Icons.person),
                    SizedBox(height: 10),

                    /** Campo password */
                    LoginWidgetUtils.buildTextField(
                        context, AppLocalizations.of(context)!.password_label, Globals.passwordcontroller, true, Icons.lock),
                    SizedBox(height: 25),

                    /** Bottoni Login e Register */
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          /** Register */
                          GestureDetector(
                            onTap: widget._handleRegister,
                            child: Material(
                              elevation: 15,
                              color: ColorUtils.dynamicAccentColor.withAlpha(255),
                              shadowColor: ColorUtils.defaultShadowColor,
                              borderRadius: BorderRadius.circular(50),
                              child: Container(
                                width: MediaQuery.of(context).size.width / 4,
                                padding: EdgeInsets.all(12),
                                child: Center(
                                  child: Text(
                                    AppLocalizations.of(context)!.register_button,
                                    style: WidgetUtils.customTextStyle(15, FontWeight.w500, Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),

                          /** Login */
                          GestureDetector(
                            onTap: widget._handleLogin,
                            child: Material(
                              elevation: 15,
                              color: ColorUtils.dynamicAccentColor.withAlpha(255),
                              shadowColor: ColorUtils.defaultShadowColor,
                              borderRadius: BorderRadius.circular(50),
                              child: Container(
                                width: MediaQuery.of(context).size.width / 4,
                                padding: EdgeInsets.all(12),
                                child: Center(
                                  child: Text(
                                    AppLocalizations.of(context)!.login_button,
                                    style: WidgetUtils.customTextStyle(15, FontWeight.w500, Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),

                    /** Bottone Reset Password */
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ForgotPage(
                                handlereset: widget._handleReset,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.forgot_password_question,
                                  style: TextStyle(
                                    color: ColorUtils.secondaryFontColor,
                                    fontFamily: 'Comfortaa',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginWidgetUtils {
  static Widget buildTextField(dynamic context, String hintText, TextEditingController controller, dynamic obscured, IconData icon) {
    return Material(
      elevation: 15,
      color: Colors.transparent,
      shadowColor: Colors.transparent,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        width: MediaQuery.of(context).size.width / 2 + 10,
        child: Center(
          child: TextField(
            style: WidgetUtils.customTextStyle(15, FontWeight.w700, ColorUtils.primaryFontColor),
            controller: controller,
            textAlign: TextAlign.justify,
            obscureText: obscured,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white.withAlpha(60)),
                borderRadius: BorderRadius.circular(50),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(50),
              ),
              hintText: hintText,
              hintStyle: WidgetUtils.customTextStyle(15, FontWeight.w700, ColorUtils.secondaryFontColor),
              contentPadding: EdgeInsets.symmetric(horizontal: 25),
              filled: true,
              suffixIcon: Padding(
                padding: const EdgeInsetsDirectional.only(end: 15.0),
                child: Icon(
                  icon,
                  color: ColorUtils.secondaryFontColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
