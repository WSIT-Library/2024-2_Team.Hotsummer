#include <DFRobot_MAX30102.h>
#include <ArduinoJson.h>
#include <Wire.h>
#include "Protocentral_MAX30205.h"

// MAX30102 및 MAX30205 객체 생성
DFRobot_MAX30102 particleSensor;
MAX30205 tempSensor;

void setup()
{
  // 시리얼 초기화
  Serial.begin(115200);        // 시리얼 모니터용
  Serial1.begin(9600);         // 블루투스 모듈 통신용
  Wire.begin();                // I2C 통신 초기화

  // MAX30102 초기화
  while (!particleSensor.begin()) {
    Serial.println("MAX30102 was not found");
    delay(1000);
  }

  particleSensor.sensorConfiguration(/*ledBrightness=*/50, /*sampleAverage=*/SAMPLEAVG_4, \
                                     /*ledMode=*/MODE_MULTILED, /*sampleRate=*/SAMPLERATE_100, \
                                     /*pulseWidth=*/PULSEWIDTH_411, /*adcRange=*/ADCRANGE_16384);

  // MAX30205 초기화
  while (!tempSensor.scanAvailableSensors()) {
    Serial.println("Couldn't find the temperature sensor, please connect the sensor.");
    delay(30000); // 30초 대기 후 재시도
  }
  tempSensor.begin();

  Serial.println("All sensors initialized successfully.");
}

int32_t SPO2; // SPO2
int8_t SPO2Valid; // SPO2 데이터 유효 여부
int32_t heartRate; // 심박수
int8_t heartRateValid; // 심박수 데이터 유효 여부

void loop()
{
  // MAX30102 데이터 읽기
  particleSensor.heartrateAndOxygenSaturation(&SPO2, &SPO2Valid, &heartRate, &heartRateValid);

  // MAX30205 데이터 읽기 (체온 측정)
  float temperature = tempSensor.getTemperature();

  // 시리얼 모니터 출력
  Serial.print("Heart Rate: ");
  Serial.print(heartRate);
  Serial.print(" bpm, SPO2: ");
  Serial.print(SPO2);
  Serial.print(" %, Temperature: ");
  Serial.print(temperature, 2); // 소수점 2자리까지 출력
  Serial.println("°C");

  // JSON 데이터 생성 및 블루투스로 전송
  sendBluetoothData(heartRate, SPO2, temperature);

  delay(2000); // 2초 간격으로 데이터 전송
}

void sendBluetoothData(int32_t heartRate, int32_t SPO2, float temperature)
{
  // JSON 형식으로 데이터 생성
  DynamicJsonDocument doc(256);
  doc["heartRate"] = heartRate;
  doc["SPO2"] = SPO2;
  doc["temperature"] = temperature;

  // JSON 데이터를 문자열로 변환
  String jsonData;
  serializeJson(doc, jsonData);

  // 블루투스를 통해 JSON 데이터 전송
  Serial1.println(jsonData);

  // 시리얼 모니터에 전송 데이터 표시
  Serial.println("Data sent via Bluetooth: " + jsonData);
}
