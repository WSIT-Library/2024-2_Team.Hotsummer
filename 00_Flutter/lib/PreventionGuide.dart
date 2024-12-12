import 'package:flutter/material.dart';

class PreventionGuide extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pushReplacementNamed('/'),
        ),
        title: Text('온열질환 예방안내'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // 설정 페이지로 이동하는 로직
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          _buildSection('예방 수칙', [
            _buildManualSection(),
            _buildListItem('충분한 수분 섭취', '물을 자주 마시세요.', Icons.local_drink),
            _buildListItem('시원한 환경 유지', '에어컨이나 선풍기를 사용하세요.', Icons.ac_unit),
            _buildListItem('가벼운 옷 착용', '통풍이 잘 되는 옷을 입으세요.', Icons.checkroom),
            _buildListItem('햇볕 피하기', '외출 시 모자나 양산을 사용하세요.', Icons.wb_sunny),
          ]),
          _buildListItem('스마트 진단', '최근 진단 결과 없음', Icons.build),
          _buildContactSection(),
        ],
      ),
    );
  }

    Widget _buildManualSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('온열질환 예방 매뉴얼'),
          SizedBox(height: 8),
          Text('온열질환 예방을 위한 매뉴얼을 확인하세요.'),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        ...items,
      ],
    );
  }

  Widget _buildListItem(String title, String subtitle, IconData icon, {bool showDivider = true}) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: Colors.blue),
          title: Text(title),
          subtitle: Text(subtitle),
          trailing: Icon(Icons.chevron_right),
        ),
        if (showDivider) Divider(),
      ],
    );
  }

  Widget _buildContactSection() {
    return ExpansionTile(
      leading: Icon(Icons.contact_phone, color: Colors.blue),
      title: Text('관련 기관 및 전화번호'),
      children: [
        ListTile(
          title: Text('질병관리청(질병관리본부)'),
          subtitle: Text('전화: 1339 (감염병 및 질병 상담 가능)'),
        ),
        ListTile(
          title: Text('응급의료센터 (119)'),
          subtitle: Text('전화: 119 (응급 상황 시)'),
        ),
        ListTile(
          title: Text('대한적십자사'),
          subtitle: Text('전화: 1577-0606 (응급처치 교육 및 지원)'),
        ),
        ListTile(
          title: Text('보건복지부'),
          subtitle: Text('전화: 129 (보건 관련 정보 및 지원)'),
        ),
        ListTile(
          title: Text('기상청'),
          subtitle: Text('전화: 131 (기상 예보, 폭염 및 기후 관련 정보)'),
        ),
      ],
    );
  }
}
