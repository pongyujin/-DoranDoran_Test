package com.doran.hardware;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.Map;

import javax.imageio.ImageIO;
import com.doran.hardware.RaspberrypiConnect;

public class test {

	public static void main(String[] args) {

		// 1. 라즈베리파이와 연결
		RaspberrypiConnect rp = new RaspberrypiConnect();
		String user = "xo";
		String host = "192.168.219.42";
		int port = 22;
		String password = "xo";
		String command = "cd projects && cd Yolo5 && python3 finala_server_boat_up1.py";
		rp.cmdRemote(user, host, port, password, command);

		// 2. 자바 소켓서버 오픈
		JavaSocketServer jss = new JavaSocketServer();
		// 초기값(포트)
		int jPort = 5000;
		jss.createUI();
		ServerSocket serverSocket = jss.createServer(jPort); // 소켓 생성

		

		// 4. 클라이언트 연결을 처리
		if (serverSocket != null) {
			while (true) { // 클라이언트 연결 대기
				try {
					Socket clientSocket = serverSocket.accept(); // 클라이언트 연결 수락
					System.out.println("클라이언트가 연결되었습니다.");
					// 클라이언트 연결 처리 후 반환된 데이터를 받음 (객체 이름, 객체 이미지)
					Map<String, Object> resultCam = jss.camConnection(clientSocket);

					// resultCam에서 obsName와 image값을 추출
					if (resultCam.get("obsName") != null) {
						String obsName = (String) resultCam.get("obsName");
						BufferedImage image = (BufferedImage) resultCam.get("image");

						// 프로젝트 실행 경로를 기준으로 파일을 저장
						String projectPath = System.getProperty("user.dir"); // 현재 프로젝트 경로 가져오기
						String relativePath = projectPath + "/src/main/resources/cameraImage/" + obsName + ".png"; // 상대
																													// 경로
																													// 설정

						// BufferedImage를 PNG 파일로 저장
						File outputfile = new File(relativePath);
						try {
							ImageIO.write(image, "png", outputfile); // "png"를 "jpg"로 변경하여 JPG로 저장 가능
							System.out.println("이미지가 파일로 저장되었습니다: " + outputfile.getAbsolutePath());

						} catch (IOException e) {
							System.out.println("이미지 파일 저장 중 오류 발생");
							e.printStackTrace();
						}
					}
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}

	}

}
