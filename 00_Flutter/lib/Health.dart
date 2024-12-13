import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class Health extends StatefulWidget {
  @override
  _HealthState createState() => _HealthState();
}

class _HealthState extends State<Health> {
  double temperature = 36.4;
  int heartRate = 84;
  int spO2 = 96;
  double? heatIllnessProbability;

  Future<void> _fetchHeatIllnessProbability() async {
    final String baseUrl = 'http://172.16.5.113:5000/get_illness_data';
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "heartbeat": heartRate,
          "temperature": temperature,
          "spo2": spO2,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        print('Response body: ${response.body}');
        setState(() {
          heatIllnessProbability = data['heat_illness_risk'];
        });
      } else {
        print("Error: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("Request error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('건강 리포트'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(labelText: '심박수 (bpm)'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  heartRate = int.tryParse(value) ?? heartRate;
                });
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: '체온 (°C)'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  temperature = double.tryParse(value) ?? temperature;
                });
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: '산소포화도 (%)'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  spO2 = int.tryParse(value) ?? spO2;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _fetchHeatIllnessProbability,
              child: Text('온열질환 확률 확인'),
            ),
            SizedBox(height: 20),
            if (heatIllnessProbability != null)
              Text(
                '온열질환 확률: ${heatIllnessProbability!.toStringAsFixed(1)} %',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              )
            else
              Text(
                '결과를 확인하세요.',
                style: TextStyle(fontSize: 16),
              ),
          ],
        ),
      ),
    );
  }
}
