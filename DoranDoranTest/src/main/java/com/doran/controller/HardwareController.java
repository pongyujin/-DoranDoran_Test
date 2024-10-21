package com.doran.controller;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.Map;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import javax.imageio.ImageIO;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.doran.hardware.JavaSocketServer;
import com.doran.hardware.PythonConnect;
import com.doran.hardware.RaspberrypiConnect;
import com.jcraft.jsch.JSch;

@Controller
public class HardwareController {

	//
	@PostMapping("/hardwareCon")
	public String rasCon(@RequestParam("sshUser") String sshUser, @RequestParam("sshHost") String sshHost,
			@RequestParam("sshPort") int sshPort, @RequestParam("sshPw") String sshPw,
			@RequestParam("sshCommand") String sshCommand, Model model) {

		// 받은 데이터를 출력
		System.out.println("SSH User: " + sshUser);
		System.out.println("SSH Host: " + sshHost);
		System.out.println("SSH Port: " + sshPort);
		System.out.println("SSH Password: " + sshPw);
		System.out.println("SSH Command: " + sshCommand);

		// 1. ssh연결
		RaspberrypiConnect rp = new RaspberrypiConnect();
		rp.cmdRemote(sshUser, sshHost, sshPort, sshPw, sshCommand);

		// 2. 자바 소켓서버 오픈
		JavaSocketServer jss = new JavaSocketServer();
		// 초기값(포트)
		int jPort = 5000;
		jss.createUI();
		ServerSocket serverSocket = jss.createServer(jPort); // 소켓 생성

		// 3. Python 파일 실행을 비동기 처리(별도의 스레드)
		// 파이썬 경로(cmd창에 where python 치면 경로 나옵니다)
		String pythonInterpreterPath = "C:\\Users\\smhrd11\\AppData\\Local\\Programs\\Python\\Python312\\python.exe";
		// 실행할 파이썬 스크립트 경로
		String pythonScriptPath = "C:\\Users\\smhrd11\\git\\DoranDoran_Test\\DoranDoranTest\\src\\main\\java\\com\\doran\\hardware\\yolo8.py";
		new Thread(() -> {
			// py파일 연결
			PythonConnect py = new PythonConnect();
			py.pythonInterpreter(pythonInterpreterPath, pythonScriptPath); // Python 스크립트 실행
		}).start();

		// 4. 클라이언트 연결을 비동기 처리 (별도의 스레드 사용)
		if (serverSocket != null) {
			ExecutorService executor = Executors.newSingleThreadExecutor();
			executor.submit(() -> {
				try {
					while (true) {
						Socket clientSocket = serverSocket.accept();
						System.out.println("클라이언트가 연결되었습니다.");
						Map<String, Object> resultCam = jss.camConnection(clientSocket);

						if (resultCam.get("obsName") != null) {
							String obsName = (String) resultCam.get("obsName");
							BufferedImage image = (BufferedImage) resultCam.get("image");

							String projectPath = System.getProperty("user.dir");
							String relativePath = projectPath + "/src/main/resources/cameraImage/" + obsName + ".png";

							File outputfile = new File(relativePath);
							try {
								ImageIO.write(image, "png", outputfile);
								System.out.println("이미지가 파일로 저장되었습니다: " + outputfile.getAbsolutePath());

								// DB저장 obsName, relativePath(obsImg)
							} catch (IOException e) {
								System.out.println("이미지 파일 저장 중 오류 발생");
								e.printStackTrace();
							}
						}
					}
				} catch (IOException e) {
					e.printStackTrace();
				}
			});
		}

		// 이제 메인 스레드는 클라이언트 연결 대기와 상관없이 다음 줄로 넘어갑니다.
		return "realTimeCamera";
	}
}
