package com.doran.hardware;

import java.io.*;
import java.net.*;
import javax.swing.*;

import org.json.JSONArray;
import org.json.JSONObject;

import com.fasterxml.jackson.databind.ObjectMapper;

import java.awt.image.*;
import javax.imageio.ImageIO;
import java.nio.ByteBuffer;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class JavaSocketServer {
	private JFrame frame;
	private JLabel label;
	private Map<Integer, Integer> classIdCount = new HashMap<>();

	// 윈도우창 설정
	public void createUI() {
		frame = new JFrame("Java UI");
		label = new JLabel();
		frame.getContentPane().add(label);
		frame.setSize(640, 480); // 창크기
		frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE); // 창 닫기시 프로그램종료
		frame.setVisible(true); // 창을 화면에 표시
	}

	// 소켓 서버 생성
	public ServerSocket createServer(int port) {
		try {
			ServerSocket serverSocket = new ServerSocket(port);
			System.out.println("서버가 포트 " + port + "에서 시작되었습니다.");
			return serverSocket; // 서버 소켓 반환
		} catch (IOException e) {
			System.out.println("서버 소켓 생성 중 오류 발생: " + e.getMessage());
			e.printStackTrace();
			return null; // 오류 발생 시 null 반환
		}
	}

	// 클라이언트 연결 후 데이터 받음
	public void ClientConnection(Socket clientSocket) {
		
		try {
			InputStream inputStream = clientSocket.getInputStream();
			System.out.println("입력 스트림을 받았습니다.");

			// 1. 이미지 크기 정보 읽기
			byte[] sizeInfo = new byte[4];
			inputStream.read(sizeInfo);
			int size = ByteBuffer.wrap(sizeInfo).getInt();
			System.out.println("이미지 크기: " + size + " 바이트");

			// 2. 이미지 데이터 읽기
			byte[] imageData = new byte[size];
			int bytesRead = 0;
			while (bytesRead < size) {
				int result = inputStream.read(imageData, bytesRead, size - bytesRead);
				if (result == -1)
					break;
				bytesRead += result;
			}
			System.out.println("이미지 데이터 수신 완료: " + bytesRead + " 바이트");

			BufferedImage image = ImageIO.read(new ByteArrayInputStream(imageData));
			if (image != null) {
				System.out.println("이미지를 성공적으로 읽었습니다. 크기: " + image.getWidth() + "x" + image.getHeight());
				updateUI(image); // 이미지를 UI에 업데이트하는 메서드 호출
			} else {
				System.out.println("이미지를 읽는데 실패했습니다.");
			}

			// 3. JSON 크기 정보 읽기 (4바이트)
			byte[] jsonSizeInfo = new byte[4];
			inputStream.read(jsonSizeInfo);
			int jsonSize = ByteBuffer.wrap(jsonSizeInfo).getInt();
			System.out.println("JSON 데이터 크기: " + jsonSize + " 바이트");

			// 5. JSON 데이터 읽기
			byte[] jsonData = new byte[jsonSize];
			int jsonBytesRead = 0;
			while (jsonBytesRead < jsonSize) {
				int result = inputStream.read(jsonData, jsonBytesRead, jsonSize - jsonBytesRead);
				if (result == -1)
					break;
				jsonBytesRead += result;
			}
			System.out.println("JSON 데이터 수신 완료: " + jsonBytesRead + " 바이트");

			// 6. JSON 데이터를 문자열로 변환
			String jsonString = new String(jsonData, "UTF-8");
			System.out.println("받은 JSON 데이터: " + jsonString);

			// JSON 배열을 파싱
			JSONArray jsonArray = new JSONArray(jsonString);

			// 배열 안의 각 객체를 처리
			for (int i = 0; i < jsonArray.length(); i++) {
				JSONObject obj = jsonArray.getJSONObject(i);

				// 각 필드를 추출
				int classId = obj.getInt("class");
				double confidence = obj.getDouble("confidence");
				JSONArray bbox = obj.getJSONArray("bbox");

				// classId 발생 횟수 기록
				classIdCount.put(classId, classIdCount.getOrDefault(classId, 0) + 1);

				// 같은객체가 3번 발견된 경우
				if (classIdCount.get(classId) == 3) {
					// 클래스 ID를 이름으로 변환
					YoloClassMap cm = new YoloClassMap();
					String className = cm.className(classId);

					// 결과 출력
					System.out.println("Class: " + className);
					System.out.println("Confidence: " + confidence);
					System.out.println("BBox: " + bbox);
					
					// DB저장
					

					// 카운트 초기화
					classIdCount.put(classId, 0);
				}
			}

		} catch (IOException e) {
			System.out.println("데이터 처리 중 오류 발생: " + e.getMessage());
			e.printStackTrace();
		} finally {
			try {
				clientSocket.close(); // 클라이언트 소켓 닫기
				System.out.println("클라이언트 연결을 종료했습니다.");
			} catch (IOException e) {
				System.out.println("클라이언트 소켓 닫기 중 오류 발생: " + e.getMessage());
			}
		}
	}

	public void updateUI(BufferedImage image) {
		ImageIcon icon = new ImageIcon(image);
		label.setIcon(icon);
		frame.repaint();
		System.out.println("UI를 업데이트했습니다.");
	}
}