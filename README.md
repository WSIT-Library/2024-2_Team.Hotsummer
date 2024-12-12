# 온열질환 디지털 헬스케어 시스템 (Hot Summer)

## 프로젝트 개요
본 프로젝트는 야외 작업자의 건강을 실시간으로 모니터링하고 온열질환을 예방하기 위한 종합적인 디지털 헬스케어 솔루션입니다.
- **각 구성 요소(Flutter, Flask Server, MySQL DB, Arudino)는 별도의 브랜치로 관리됩니다.**

## 주요 기능

### 1. 실시간 건강 데이터 모니터링
- Arduino Uno 기반 센서를 통한 실시간 생체 데이터 수집
- 심박수, 체온, 혈중 산소포화도 측정
- Bluetooth Classic(HC-05)을 통한 데이터 전송

### 2. 사용자 인터페이스
- Flutter 기반 크로스 플랫폼 모바일 애플리케이션
- 직관적인 데이터 시각화 및 건강 상태 표시
- 실시간 체온 그래프 및 건강 상태 대시보드

### 3. 온열질환 위험도 분석
- 수집된 생체 데이터 기반 온열질환 위험도 평가
- 임계치 도달 시 사용자 알림
- AI 기반 건강 리포트 제공

### 4. 데이터 관리
- MySQL 데이터베이스를 통한 사용자 및 건강 데이터 저장
- Flask 서버를 통한 데이터 처리 및 분석

## 기술 스택
- **하드웨어**: Arduino Uno, MAX30102, MAX30205, HC-05 Bluetooth Module
- **모바일 앱**: Flutter (Dart)
- **백엔드**: Python, Flask
- **데이터베이스**: MySQL
- **데이터 시각화**: FL Chart

## 시스템 아키텍처
1. **데이터 수집**: Arduino 센서
2. **데이터 전송**: Bluetooth Classic
3. **애플리케이션**: Flutter 모바일 앱
4. **서버 처리**: Flask 서버
5. **데이터 저장**: MySQL 데이터베이스

## 개발 환경 및 버전

### 소프트웨어 환경
- **Flutter**: v3.5.3
- **Dart**: v3.1.0
- **Python**: v3.12.3
- **Flask**: v3.0.3
- **MySQL**: v8.0.40

### 하드웨어 환경
- **Arduino**: Uno R3
- **Bluetooth Module**: HC-05
- **센서**:
  - MAX30102 심박수/산소포화도 센서
  - MAX30205 체온 센서

### 개발 도구
- **IDE**: 
  - Android Studio
  - Visual Studio Code
- **빌드 도구**:
  - Flutter pub
  - pip3 (Python 패키지 관리)

### 테스트 환경
- **모바일 OS**: Android 10+
- **최소 지원 Android 버전**: Android 8.0 (API 레벨 26)

## 주요 화면 구성
- 메인 대시보드
- 사용자 데이터 체크
- 온열질환 예방 가이드
- 건강 리포트
- 사용자 관리 (로그인/회원가입)

## 설치 및 실행

### 하드웨어 준비
- Arduino Uno 설정
- 센서(MAX30102, MAX30205) 연결
- HC-05 Bluetooth 모듈 페어링

### 소프트웨어 설치
1. Flutter 개발 환경 설정
2. Python 및 Flask 서버 환경 구성
3. MySQL 데이터베이스 설정

### 애플리케이션 실행

```bash
# Flutter 앱 실행
flutter pub get
flutter run

# Flask 서버 실행
python app.py
```

## 기대 효과
- 야외 작업자의 건강 관리 및 온열질환 예방
- 실시간 건강 모니터링을 통한 산업재해 감소
- 디지털 헬스케어 기술의 혁신적 접근

## 향후 개발 계획
- 클라우드 연동을 통한 데이터 통합 관리
- 머신러닝 기반 예측 모델 고도화
- 추가 센서 통합 및 기능 확장

## Hot Summer 프로젝트 라이선스

### 사용 목적
- 본 소프트웨어는 온열질환 예방 및 건강 모니터링 목적으로만 사용할 수 있습니다.
- 의료적 진단의 대체 수단으로 사용할 수 없습니다.

### 책임 제한
- 제공되는 건강 데이터와 분석 결과는 참고용이며, 의료적 진단으로 간주되지 않습니다.
- 최종 건강 판단은 반드시 의료 전문가와 상담해야 합니다.

### 라이선스 준수
- 상업적 사용 및 2차 저작물 생성이 허용됩니다.
- 원저작자 크레딧을 유지해야 합니다.

## 기여 및 문의
### 연락처 정보
- **Arduino 담당자 이메일/깃허브**: [dmlqk123@naver.com](mailto:dmlqk123@naver.com) / https://github.com/Kjihoo

- **Flutter 담당자 이메일/깃허브**: [kdm000407@gmail.com](mailto:kdm000407@gmail.com) / https://github.com/gweng0407

- **MySQL 및 서브 Flutter 담당자 이메일/깃허브**: [youngkujo231@gmail.com](mailto:youngkujo231@gmail.com) / https://github.com/charlie231

