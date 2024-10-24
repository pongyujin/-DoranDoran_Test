package com.doran.controller;

import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;

public class HwMotorController {

    // 모터 속도를 설정하는 메서드
    public static void setMotorSpeed(int speed) {
        try {
            // 라즈베리파이의 IP와 Flask 서버 포트에 맞게 URL 설정
            String targetUrl = "http://192.168.219.47:5000/set_speed";

            // URL 객체 생성 (요청을 보낼 대상 URL)
            URL url = new URL(targetUrl);
            // URL 연결을 HttpURLConnection으로 열기
            HttpURLConnection connection = (HttpURLConnection) url.openConnection();

            // HTTP 요청 설정 (POST 요청 사용)
            connection.setRequestMethod("POST");
            // 요청 본문의 데이터 형식 설정 (JSON)
            connection.setRequestProperty("Content-Type", "application/json");
            // 서버로 데이터를 전송할 수 있도록 설정
            connection.setDoOutput(true);

            // JSON 형식의 데이터 생성 
            String jsonInputString = "{\"speed\": " + speed + "}";

            // 요청 본문에 JSON 데이터를 전송
            try (OutputStream os = connection.getOutputStream()) {
                // JSON 문자열을 바이트 배열로 변환하여 전송
                byte[] input = jsonInputString.getBytes(StandardCharsets.UTF_8);
                os.write(input, 0, input.length);
            }

            // 서버로부터의 응답 코드 확인
            int responseCode = connection.getResponseCode();
            System.out.println("Response Code: " + responseCode); // 서버 응답 코드 출력

            // 연결 종료
            connection.disconnect();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static void main(String[] args) {

    	// 모터속도값 0(정지) ~ 100(풀파워)
        setMotorSpeed(0);
    }
}
