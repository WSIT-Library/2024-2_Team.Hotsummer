import 'package:flutter/material.dart';
import 'DataCheck.dart';
import 'PreventionGuide.dart';
import 'Login.dart';
import 'Health.dart';

//메인 페이지에 현재 날씨/위험 정보 표시되면 좋을듯
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hot Summer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false, // DEBUG 표시 제거
      routes: {
        '/': (context) => MyHomePage(title: 'Hot Summer'),
        '/datacheck': (context) => DataCheck(),
        '/preventionguide': (context) => PreventionGuide(),
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              _showNotificationPopup(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16), // 이미지 위/아래 간격 설정
            child: Image.asset(
              'assets/logo.png',
              height: 150, // 이미지 높이 설정
              fit: BoxFit.contain, // 이미지 비율 유지
            ),
          ),
          Expanded(
            flex: 1, // 버튼 부분에 더 많은 공간 할당
            child: GridView.count(
              crossAxisCount: 2,
              padding: EdgeInsets.all(16),
              childAspectRatio: 1.5, // 버튼 높이 변경 안되면 삭제
              children: [
                _buildButton(context, '사용자 데이터 체크', const Color.fromARGB(255, 142, 213, 144), DataCheck()),
                _buildButton(context, '온열질환 예방 안내', const Color.fromARGB(255, 33, 217, 199), PreventionGuide()),
                _buildButton(context, '건강 리포트', const Color.fromARGB(255, 152, 195, 231), Health()), // 기록된 데이터대로 AI 기반 건강 위험도 예측, 주간/월간 건강 리포트 제공?, PDF 파일 제공까지 할수도
                _buildButton(context, '사용자 관리', const Color.fromARGB(255, 158, 169, 236), Login()),
              ],
            ),
          ),
          Expanded(
            flex: 1, // 뉴스 부분에 적은 공간 할당
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    '바이오헬스 NEWS',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: [
                      _buildNewsItem('공지사항1'),
                      _buildNewsItem('공지사항2'),
                      _buildNewsItem('공지사항3'),
                      // 추가 뉴스 항목...
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showNotificationPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("알림"),
          content: Text("추가 예정"),
          actions: [
            TextButton(
              child: Text("확인"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildButton(BuildContext context, String text, Color color, Widget? destination) {
    return GestureDetector(
      onTap: () {
        if (destination != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => destination),
          );
        }
      },
      child: Card(
        color: color,
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildNewsItem(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(text),
    );
  }
}
