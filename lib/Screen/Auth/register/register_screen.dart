import 'package:appfront/Screen/Auth/register/widgets/custom_form_field.dart';
import 'package:appfront/Screen/Auth/register/widgets/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _id = TextEditingController();
  final TextEditingController _nickname = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _pwdKey = GlobalKey<FormState>();

  bool idDuplicateFlag = false;
  final RegExp _emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  String _birth = '';
  bool emailCheck = true;

  String name = '';
  String nickname = '';
  String email = '';
  String username = '';
  String password = '';
  String birth = '';
  String phone = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text('회원가입'),
        ),
        body: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                idInput(context),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                nicknameInput(context),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                emailInput(context),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                nameInput(context),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                passwordInput(context),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                passwordCheckInput(context),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                birthInput(context),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                phoneInput(context),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                enterBtn(context)
              ],
            ),
          ),
        ));
  }

  ElevatedButton enterBtn(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            if (_birth == "") {
              Fluttertoast.showToast(
                msg: "생일을 입력해주세요.",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: const Color(0xff39c5bb),
                textColor: Colors.white,
                fontSize: 16,
              );
            } else if (idDuplicateFlag) {
              setState(() {
                name = _id.text;
                nickname = _nickname.text;
                email = _email.text;
                username = _username.text;
                password = _password.text;
                phone = _phone.text;
              });
              Map<String, dynamic> userData = {
                'name': name,
                'nickname': nickname,
                'email': email,
                'username': username,
                'password': password,
                'birth': birth,
                'phone': phone,
              };
              register(userData);
              Navigator.pop(context);
            } else {
              Fluttertoast.showToast(
                msg: "아이디 중복확인이 필요합니다.",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: const Color(0xff39c5bb),
                textColor: Colors.white,
                fontSize: 16,
              );
            }
          }
        },
        child: const Text("확인"));
  }

  SizedBox phoneInput(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.6,
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "필수 입력값입니다.";
          }
          return null;
        },
        maxLength: 13,
        controller: _phone,
        decoration: const InputDecoration(
          counterText: '',
          hintText: "전화번호",
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xff39c5bb),
            ),
          ),
        ),
        onChanged: (value) {
          setState(() {
            _phone.value = _phone.value.copyWith(
              // 입력된 숫자를 정규식에 맞게 변환하여 적용
              text: value.replaceAllMapped(
                RegExp(r'(\d{3})(\d{4})(\d{4})'),
                (m) => '${m[1]}-${m[2]}-${m[3]}',
              ),
              selection: TextSelection.collapsed(offset: value.length),
            );
          });
        },
      ),
    );
  }

  Container birthInput(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.6,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xff39c5bb),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "생일: $_birth",
            style: TextStyle(
              fontSize: 17,
              color: Colors.black.withOpacity(0.6),
            ),
          ),
          IconButton(
              onPressed: () {
                showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now())
                    .then((selectedDate) {
                  if (selectedDate != null) {
                    setState(() {
                      birth = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
                          .format(selectedDate);
                      _birth = DateFormat("yyyy-MM-dd").format(selectedDate);
                    });
                  }
                });
              },
              icon: const Icon(Icons.date_range))
        ],
      ),
    );
  }

  SizedBox passwordInput(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width * 0.6,
        child: CustomFormField(
          obscureText: true,
          text: "비밀번호",
          controller: _password,
        ));
  }

  SizedBox passwordCheckInput(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.6,
      child: Form(
        key: _pwdKey,
        child: TextFormField(
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "필수 입력값입니다.";
            }
            if (value != _password.text) {
              return "비밀번호가 일치하지 않습니다.";
            }
            return null;
          },
          maxLength: 13,
          obscureText: true,
          decoration: const InputDecoration(
            counterText: '',
            hintText: "비밀번호 확인",
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xff39c5bb),
              ),
            ),
          ),
          onChanged: (value) {
            _pwdKey.currentState!.validate();
          },
        ),
      ),
    );
  }

  SizedBox nameInput(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width * 0.6,
        child: CustomFormField(
          obscureText: false,
          text: "이름",
          controller: _username,
        ));
  }

  SizedBox emailInput(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.6,
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "필수 입력값입니다.";
          } else if (!emailCheck) {
            return "이메일 형식에 맞지 않습니다.";
          }
          return null;
        },
        controller: _email,
        decoration: InputDecoration(
          errorText: emailCheck ? null : "이메일 형식에 맞지 않습니다",
          hintText: "이메일",
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xff39c5bb),
            ),
          ),
        ),
        onChanged: (value) {
          if (!_emailRegExp.hasMatch(value)) {
            setState(() {
              emailCheck = false;
            });
          } else {
            setState(() {
              emailCheck = true;
            });
          }
        },
      ),
    );
  }

  SizedBox nicknameInput(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.6,
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "필수 입력값입니다.";
          }
          return null;
        },
        controller: _nickname,
        decoration: const InputDecoration(
          hintText: "닉네임",
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xff39c5bb),
            ),
          ),
        ),
      ),
    );
  }

  Row idInput(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            child: CustomFormField(
              obscureText: true,
              text: "아이디",
              controller: _id,
            )),
        ElevatedButton(
          onPressed: () {
            setState(() {
              name = _id.text;
            });
            idDuplicateFlag ? null : checkUserIdDuplicate(name);
          },
          style: ButtonStyle(
            side: MaterialStateProperty.all(
              BorderSide(
                color: idDuplicateFlag ? const Color(0xff39c5bb) : Colors.red,
              ),
            ),
          ),
          child: const Text("중복확인"),
        )
      ],
    );
  }

  void checkUserIdDuplicate(String inputData) async {
    String url = 'https://api.parkchargego.link/auth/check-username-duplicate/';
    // URL을 올바르게 형성하기 위해 Uri 클래스를 사용합니다.
    Uri uri = Uri.parse('$url$inputData');
    http.Response response = await http.get(uri);

    if (response.statusCode == 200) {
      print(uri);
      Fluttertoast.showToast(
        msg: "사용할 수 있는 아이디입니다.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: const Color(0xff39c5bb),
        textColor: Colors.white,
        fontSize: 16,
      );
      setState(() {
        idDuplicateFlag = !idDuplicateFlag;
      });
    } else {
      print(uri);
      Fluttertoast.showToast(
        msg: '사용할 수 없는 아이디입니다.',
        gravity: ToastGravity.BOTTOM,
        backgroundColor: const Color(0xff39c5bb),
      );
    }
  }
}

void register(Map<String, dynamic> userData) async {
  String url = 'https://api.parkchargego.link/auth/register';
  Uri uri = Uri.parse(url);
  http.Response response = await http.post(uri, body: userData);

  if (response.statusCode == 201) {
    CustomToast.showToast("회원가입이 완료되었습니다.");
  } else {
    print(uri);
    CustomToast.showToast("이메일 혹은 전화번호가 중복되었습니다.");
  }
}

class ButtonStateManager {
  bool idDuplicateFlag = false;
}
