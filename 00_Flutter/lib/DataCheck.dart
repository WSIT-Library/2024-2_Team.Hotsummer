import 'package:flutter/material.dart';
import 'package:bluetooth_classic/models/device.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:bluetooth_classic/bluetooth_classic.dart';
import 'package:fl_chart/fl_chart.dart'; // fl_chart 패키지 추가

class DataCheck extends StatefulWidget {
  @override
  _DataCheckState createState() => _DataCheckState();
}

class _DataCheckState extends State<DataCheck> {
  double temperature = 0;
  int heartRate = 0;
  int spO2 = 0;
  String _platformVersion = 'Unknown';
  final _bluetoothClassicPlugin = BluetoothClassic();
  List<Device> _devices = [];
  int _deviceStatus = Device.disconnected;
  StreamSubscription? _deviceStatusSubscription;
  StreamSubscription? _deviceDataSubscription;
  List<FlSpot> temperatureData = []; // 체온 데이터를 저장할 리스트

  @override
  void initState() {
    super.initState();
    initPlatformState();
    _startBluetoothListeners();
  }

  void _startBluetoothListeners() {
    _deviceStatusSubscription =
        _bluetoothClassicPlugin.onDeviceStatusChanged().listen((event) {
      setState(() {
        _deviceStatus = event;
      });
    });

    _deviceDataSubscription =
        _bluetoothClassicPlugin.onDeviceDataReceived().listen((event) {
      try {
        String dataString = String.fromCharCodes(event);
        print("수신된 데이터: $dataString");

        if (dataString.isNotEmpty) {
          var jsonData = jsonDecode(dataString);
          if (jsonData is Map<String, dynamic>) {
            setState(() {
              temperature = jsonData['temperature']?.toDouble() ?? 0;
              heartRate = jsonData['heartRate']?.toInt() ?? 0;
              spO2 = jsonData['spO2']?.toInt() ?? 0;

              // 체온 데이터를 그래프에 추가
              temperatureData.add(FlSpot(temperatureData.length.toDouble(), temperature));
            });
          } else {
            print("올바르지 않은 JSON 형식");
          }
        } else {
          print("수신된 데이터가 비어 있습니다.");
        }
      } catch (e) {
        print("JSON 변환 오류: $e");
      }
    });
  }

  Future<void> initPlatformState() async {
    try {
      _platformVersion =
          await _bluetoothClassicPlugin.getPlatformVersion() ?? 'Unknown platform version';
    } on PlatformException {
      _platformVersion = 'Failed to get platform version.';
    }
    if (!mounted) return;
    setState(() {});
  }

  Future<void> _getDevices() async {
    var res = await _bluetoothClassicPlugin.getPairedDevices();
    setState(() {
      _devices = res;
    });
  }

  @override
  void dispose() {
    _deviceStatusSubscription?.cancel();
    _deviceDataSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('사용자 데이터 체크'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pushReplacementNamed('/'),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () {
              _showPopup(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildTemperatureDisplay(),
            _buildTemperatureGraph(),
            _buildCurrentStatus(),
          ],
        ),
      ),
    );
  }

  void _showPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("사용법"),
          content: Text(
            "1. 먼저 아두이노 기기와 블루투스 연결합니다.\n"
            "2. 앱 첫 실행 시 '권한 체크' 버튼을 클릭합니다.\n"
            "3. 아두이노를 연결 완료 했을 시 '연결된 장치 확인' 버튼을 클릭 후 연결이 필요한 아두이노 기기를 클릭합니다."
          ),
          actions: [
            TextButton(
              child: Text("닫기"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildTemperatureDisplay() {
    return Container(
      padding: EdgeInsets.all(32.0),
      child: Column(
        children: [
          Text(
            temperature.toStringAsFixed(1),
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          ),
          Text('체온 (°C)'),
        ],
      ),
    );
  }

  Widget _buildTemperatureGraph() {
    return Container(
    padding: EdgeInsets.all(16.0),
    height: 300, // 그래프 높이
    child: LineChart(
      LineChartData(
        gridData: FlGridData(show: true),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: Colors.grey, width: 1),
        ),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 20,
              getTitlesWidget: (value, meta) => Text('${value.toInt()}s'),
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) => Text('${value.toInt()}°C'),
            ),
          ),
        ),
        lineBarsData: [ // 올바른 위치로 이동
          LineChartBarData(
            spots: temperatureData,
            isCurved: true,
            barWidth: 3,
            isStrokeCapRound: true,
            belowBarData: BarAreaData(show: true),
            color: Colors.blue,
          ),
        ],
      )
    ),
  );
}

  Widget _buildCurrentStatus() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('현재 상태', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          _buildStatusItem(Icons.favorite, '심박수', '$heartRate bpm'),
          _buildStatusItem(Icons.opacity, '혈중 산소포화도', '$spO2%'),
          SizedBox(height: 16),
          _buildBluetoothButtons(),
        ],
      ),
    );
  }

  Widget _buildBluetoothButtons() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            onPressed: () async {
              await _bluetoothClassicPlugin.initPermissions();
            },
            child: Text("권한 체크"),
          ),
          ElevatedButton(
            onPressed: _getDevices,
            child: Text('연결된 장치 확인'),
          ),
          if (_deviceStatus == Device.connected)
            ElevatedButton(
              onPressed: () async {
                await _bluetoothClassicPlugin.disconnect();
                setState(() {
                  temperature = 0;
                  heartRate = 0;
                  spO2 = 0;
                });
              },
              child: Text('연결 종료'),
            ),
          Text('현재 안드로이드 버전 : $_platformVersion\n'),
          ..._devices.map((device) => TextButton(
                onPressed: () async {
                  await _bluetoothClassicPlugin.connect(
                      device.address, "00001101-0000-1000-8000-00805f9b34fb");
                  setState(() {
                    _devices.clear();
                  });
                },
                child: Text(device.name ?? device.address),
              )),
        ],
      ),
    );
  }

  Widget _buildStatusItem(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon),
          SizedBox(width: 16),
          Expanded(child: Text(label)),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
