import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:morpheus_launcher_gui/globals.dart';
import 'package:morpheus_launcher_gui/main.dart';
import 'package:morpheus_launcher_gui/views/login_page.dart';
import 'package:morpheus_launcher_gui/views/main_page.dart';

class ForgotPage extends StatefulWidget {
  final VoidCallback _handleReset;

  const ForgotPage({Key? key, required void Function() handlereset})
      : _handleReset = handlereset,
        super(key: key);

  @override
  State<ForgotPage> createState() => _ForgotPageState();
}

class _ForgotPageState extends State<ForgotPage> {
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
                          "Password Reset",
                          style: TextStyle(
                            color: Colors.white,
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
                        context, AppLocalizations.of(context)!.new_password_label, Globals.passwordcontroller, true, Icons.lock),
                    SizedBox(height: 10),

                    /** Campo codice speciale */
                    LoginWidgetUtils.buildTextField(context, AppLocalizations.of(context)!.otp_code_label, Globals.codecontroller, false, Icons.pin),
                    SizedBox(height: 25),

                    /** Bottone Reset Password */
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          /** Login */
                          GestureDetector(
                            onTap: widget._handleReset,
                            child: Material(
                              elevation: 15,
                              color: ColorUtils.dynamicAccentColor.withAlpha(255),
                              shadowColor: ColorUtils.defaultShadowColor,
                              borderRadius: BorderRadius.circular(50),
                              child: Container(
                                width: MediaQuery.of(context).size.width / 2 + 10,
                                padding: EdgeInsets.all(12),
                                child: Center(
                                  child: Text(
                                    AppLocalizations.of(context)!.reset_password_button,
                                    style: WidgetUtils.customTextStyle(15, FontWeight.w500, Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
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
