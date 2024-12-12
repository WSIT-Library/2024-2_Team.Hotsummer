import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: JoinMembership(),
    );
  }
}

class JoinMembership extends StatefulWidget {
  const JoinMembership({Key? key}) : super(key: key);

  @override
  _JoinMembershipState createState() => _JoinMembershipState();
}

class _JoinMembershipState extends State<JoinMembership> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _signUp() async {
    String name = _nameController.text;
    String id = _usernameController.text;
    String password = _passwordController.text;

    if (name.isEmpty || id.isEmpty || password.isEmpty) {
        _showMessage('이름, 아이디, 비밀번호를 모두 입력해주세요.');
        return;
    }

    var checkUserUrl = Uri.parse('http://[Flask서버주소]/check_user'); // Flask 서버 주소 변경 필요
    try {
        var response = await http.post(
            checkUserUrl,
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
                'id': id, // 아이디로 사용
            }),
        );

        if (response.statusCode == 200) {
            var responseData = json.decode(response.body);
            if (responseData['exists']) {
                _showMessage('이미 존재하는 아이디입니다. 회원가입이 불가능합니다.');
            } else {
                // 회원가입 API 호출
                var signUpUrl = Uri.parse('http://[Flask서버주소]/signup'); // 회원가입 API 주소
                var signUpResponse = await http.post(
                    signUpUrl,
                    headers: {'Content-Type': 'application/json'},
                    body: json.encode({
                        'name': name, // 이름 추가
                        'id': id, // 아이디로 사용
                        'password': password,
                    }),
                );

                if (signUpResponse.statusCode == 201) {
                    _showMessage('회원가입이 완료되었습니다.');
                } else {
                    _showMessage('회원가입에 실패했습니다. 다시 시도해주세요.');
                }
            }
        } else {
            _showMessage('서버 오류가 발생했습니다. 다시 시도해주세요.');
        }
    } catch (e) {
        _showMessage('서버와의 연결에 실패했습니다. 다시 시도해주세요.');
    }
  }

  void _showMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('확인'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('회원가입', style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Image.asset(
                    'assets/logo.png',
                    height: 200,
                  ),
                  SizedBox(height: 40),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: '이름을 입력해주세요',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: '아이디를 입력해주세요',
                      prefixIcon: Icon(Icons.account_circle),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: '비밀번호를 입력해주세요',
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 100),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _signUp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  '회원가입 완료하기',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
