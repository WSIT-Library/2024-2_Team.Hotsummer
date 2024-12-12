from flask import Flask, request, jsonify
from flask_cors import CORS
import pymysql

app = Flask(__name__)
CORS(app)  # 모든 도메인에서의 요청을 허용

# MySQL 데이터베이스 연결 설정
db = pymysql.connect(
    host="localhost",
    user="root",
    password="1234",
    database="hotsummer"
)

# 회원가입 API 엔드포인트
@app.route('/signup', methods=['POST'])
def signup():
    try:
        data = request.get_json()
        name = data.get('name')
        user_id = data.get('id')
        password = data.get('password')

        with db.cursor() as cursor:
            # 아이디 중복 체크
            sql_check = "SELECT * FROM member WHERE id=%s"
            cursor.execute(sql_check, (user_id,))
            result = cursor.fetchone()
            if result:
                return jsonify({"error": "이미 존재하는 아이디입니다."}), 409  # Conflict

            # 회원가입 정보 삽입
            sql_insert = "INSERT INTO member (name, id, password) VALUES (%s, %s, %s)"
            cursor.execute(sql_insert, (name, user_id, password))
            db.commit()  # 변경 사항 저장

            return jsonify({"message": "회원가입이 완료되었습니다."}), 201  # Created
    except Exception as e:
        return jsonify({"error": str(e)}), 500  # Internal Server Error

# member 테이블 데이터 가져오기 엔드포인트
@app.route('/check_user', methods=['POST'])
def check_user():
    try:
        data = request.get_json()
        user_id = data.get('id')
        password = data.get('password')

        with db.cursor(pymysql.cursors.DictCursor) as cursor:
            sql = "SELECT * FROM member WHERE id=%s AND password=%s"
            cursor.execute(sql, (user_id, password))
            result = cursor.fetchone()
            if result:
                return jsonify({"exists": True})  # 회원이 존재함
            else:
                return jsonify({"exists": False})  # 회원이 존재하지 않음
    except Exception as e:
        return jsonify({"error": str(e)})

# illness 테이블 데이터 가져오기 엔드포인트
@app.route('/get_illness_data', methods=['POST'])
def get_illness_data():
    data = request.get_json()
    heart_rate = data.get('heartbeat')
    temperature = data.get('temperature')
    spO2 = data.get('spo2')

    try:
        with db.cursor(pymysql.cursors.DictCursor) as cursor:
            # 약간의 오차를 허용하는 SQL 쿼리
            sql = """
            SELECT * FROM illness
            WHERE heartbeat = %s
              AND ABS(temperature - %s) < 0.1
              AND ABS(spo2 - %s) < 0.1
            """
            cursor.execute(sql, (heart_rate, temperature, spO2))
            result = cursor.fetchone()
            if result:
                print("Result found:", result)  # 결과가 있을 경우
                return jsonify(result)
            else:
                print("No matching data found.")  # 결과가 없을 경우
                return jsonify({'heat_illness_risk': None})  # 일치하는 데이터가 없을 경우
    except Exception as e:
        return jsonify({"error": str(e)})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)