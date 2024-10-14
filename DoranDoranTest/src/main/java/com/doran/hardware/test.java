package com.doran.hardware;

import java.io.IOException;
import java.net.ServerSocket;
import java.net.Socket;

public class test {

	public static void main(String[] args) {

		// 1. 라즈베리파이와 연결
		RaspberrypiConnect rp = new RaspberrypiConnect();
		String user = "xo";
		String host = "192.168.219.47";
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

		// 3. Python 파일 실행을 비동기 처리 (별도의 스레드)
		new Thread(() -> {
			// py파일 연결
			PythonConnect py = new PythonConnect();
			py.python(); // Python 스크립트 실행
		}).start();

		// 4. 클라이언트 연결을 처리
		if (serverSocket != null) {
			while (true) { // 클라이언트 연결 대기
				try {
					System.out.println("클라이언트 연결 대기 중...");
					Socket clientSocket = serverSocket.accept(); // 클라이언트 연결 수락
					System.out.println("클라이언트가 연결되었습니다.");
					// 클라이언트 연결 처리
					jss.ClientConnection(clientSocket);
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}

	}
}
