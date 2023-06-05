import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'change_password_screen.dart';
import 'login_screen.dart';

class Otp extends StatelessWidget {
  const Otp({
    Key? key,
    required this.otpController,
  }) : super(key: key);
  final TextEditingController otpController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 50,
      child: TextFormField(
        controller: otpController,
        keyboardType: TextInputType.number,
        style: Theme.of(context).textTheme.titleLarge,
        textAlign: TextAlign.center,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly
        ],
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          }
          if (value.isEmpty) {
            // FocusScope.of(context).previousFocus();
            FocusScope.of(context).requestFocus();
          }
        },
        decoration: InputDecoration(
          hintText: ('0'),
          labelStyle: TextStyle(
            color: Colors.black,
            fontSize: 14,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                BorderSide(color: Colors.black), // Set the border side to none
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.blue.shade900),
          ),
          filled: true,
          fillColor: Color.fromARGB(255, 251, 234, 234),
        ),
        onSaved: (value) {},
      ),
    );
  }
}

class OtpScreen extends StatefulWidget {
  final EmailOTP myauth;
  final int userID;
  final String emailUser;

  const OtpScreen({Key? key, required this.myauth, required this.userID, required this.emailUser})
      : super(key: key);
  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  TextEditingController otp1Controller = TextEditingController();
  TextEditingController otp2Controller = TextEditingController();
  TextEditingController otp3Controller = TextEditingController();
  TextEditingController otp4Controller = TextEditingController();

  EmailOTP myauth = EmailOTP();

  String otpController = "1234";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[200],
      appBar: AppBar(
        title: const Text('Xác thực mã OTP'),
        backgroundColor: Colors.blue[900],
        elevation: 0,
      ),
      body: ListView(
        children: [
          Column(
            children: [
              const SizedBox(height: 25),
              // const Icon(Icons.dialpad_rounded, size: 50),
              Image.asset(
                "assets/images/email.png",
                width: MediaQuery.of(context).size.width * 0.45,
                height: MediaQuery.of(context).size.width * 0.45,
              ),
              const SizedBox(height: 30),
              const Text(
                "Nhập mã OTP đã được gửi tới gmail",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Otp(
                    otpController: otp1Controller,
                  ),
                  Otp(
                    otpController: otp2Controller,
                  ),
                  Otp(
                    otpController: otp3Controller,
                  ),
                  Otp(
                    otpController: otp4Controller,
                  ),
                ],
              ),
              const SizedBox(height: 25),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () async{
                      myauth.setConfig(
                          appEmail: "contact@hdevcoder.com",
                          appName: "Email OTP",
                          userEmail: widget.emailUser,
                          otpLength: 4,
                          otpType: OTPType.digitsOnly);
                        if (await myauth.sendOTP() == true) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("Mã OTP đã được gửi đi"),
                          ));
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OtpScreen(
                                      myauth: myauth,
                                      userID: widget.userID,
                                      emailUser: widget.emailUser,
                                    )));
                        } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("Oops, Mã OTP gửi thất bại!"),
                          ));
                        }
                    },
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.hovered)) {
                            return Colors.black.withOpacity(0.04);
                          }
                          return Colors.black; // default value
                        },
                      ),
                    ),
                    child: RichText(
                      text: TextSpan(
                        text: 'Chưa nhận được mã OTP? ',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(
                            text: 'Gửi lại',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade900,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.75,
                height: 55,
                child: ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            35), // Adjust the value to your desired roundness
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.hovered)) {
                          return Colors.black;
                        }
                        return Colors.blue.shade900;
                      },
                    ),
                  ),
                  onPressed: () async {
                    if (await widget.myauth.verifyOTP(
                            otp: otp1Controller.text +
                                otp2Controller.text +
                                otp3Controller.text +
                                otp4Controller.text) ==
                        true) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Mã OTP đã được xác minh thành công"),
                      ));
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ChangePasswordScreen(widget.userID)),
                        (route) => false,
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Mã OTP không hợp lệ"),
                      ));
                    }
                  },
                  child: const Text(
                    "XÁC NHẬN",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ],
      ),
    );
  }
}
