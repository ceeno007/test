import 'package:flutter/material.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'dart:ui' as ui;

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PlatformWebViewController _controller = PlatformWebViewController(
    const PlatformWebViewControllerCreationParams(),
  )..loadRequest(
      LoadRequestParams(
        uri: Uri.parse(
            'https://my.spline.design/untitled-884722684242572a63d9489533175145/'),
      ),
    );

  TextEditingController numberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var containerHeight = screenSize.height * 0.5;
    var containerWidth = screenSize.width * 0.8;
    var maxWidth = 600.0; // Maximum width for the container
    var maxHeight = 500.0; // Maximum height for the container

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Stack(
          children: [
            Positioned.fill(
              child: PlatformWebViewWidget(
                PlatformWebViewWidgetCreationParams(controller: _controller),
              ).build(context),
            ),
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ui.ImageFilter.blur(sigmaX: 80, sigmaY: 80),
                  child: Container(
                    padding: EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                      ),
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.2),
                          Colors.white.withOpacity(0.1),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 20,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    height: containerHeight > maxHeight
                        ? maxHeight
                        : containerHeight,
                    width:
                        containerWidth > maxWidth ? maxWidth : containerWidth,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Found an item? Input the code on the tag here: 😀',
                          style: TextStyle(
                            fontSize: screenSize.width * 0.05 > 30
                                ? 30
                                : screenSize.width * 0.05,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: screenSize.height * 0.03),
                        PinCodeTextField(
                          appContext: context,
                          length: 6,
                          obscureText: false,
                          animationType: AnimationType.fade,
                          validator: (v) {
                            if (v!.length < 6) {
                              return "Enter 6 numbers";
                            } else {
                              return null;
                            }
                          },
                          pinTheme: PinTheme(
                            shape: PinCodeFieldShape.box,
                            borderRadius: BorderRadius.circular(12),
                            fieldHeight: screenSize.width * 0.1 > 60
                                ? 60
                                : screenSize.width * 0.1,
                            fieldWidth: screenSize.width * 0.1 > 60
                                ? 60
                                : screenSize.width * 0.1,
                            inactiveFillColor: Colors.white.withOpacity(0.8),
                            activeFillColor: Colors.white.withOpacity(0.8),
                            selectedFillColor: Colors.white.withOpacity(0.8),
                            inactiveColor: Colors.grey,
                            activeColor: Colors.blueAccent,
                            selectedColor: Colors.blue,
                          ),
                          cursorColor: Colors.black,
                          beforeTextPaste: (text) {
                            debugPrint("Allowing to paste $text");
                            // Allow paste
                            return true;
                          },
                          keyboardType: TextInputType.number,
                          animationDuration: Duration(milliseconds: 300),
                          backgroundColor: Colors.transparent,
                          enableActiveFill: true,
                          controller: numberController,
                          onCompleted: (v) {
                            print("Completed");
                          },
                          onChanged: (value) {
                            setState(() {});
                          },
                        ),
                        SizedBox(height: screenSize.height * 0.05),
                        ElevatedButton(
                          onPressed: () {
                            print("Entered code: ${numberController.text}");
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            padding: EdgeInsets.symmetric(
                              vertical: screenSize.height * 0.02,
                              horizontal: screenSize.width * 0.1 > 80
                                  ? 80
                                  : screenSize.width * 0.1,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            textStyle: TextStyle(
                              fontSize: screenSize.width * 0.06 > 24
                                  ? 24
                                  : screenSize.width * 0.06,
                              fontWeight: FontWeight.bold,
                            ),
                            elevation: 5,
                            shadowColor: Colors.black26,
                          ),
                          child: Text('Found It!'),
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
    );
  }
}
