package com.doran.hardware;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.IOException;

public class PythonConnect {
    public void python() {
        try {
            // Python 인터프리터 경로 (Python이 설치된 경로로 수정)
        	// cmd창에 where python 치면 경로 나옵니다
            String pythonInterpreterPath = "C:\\Users\\smhrd11\\AppData\\Local\\Programs\\Python\\Python312\\python.exe";

            // 실행할 파이썬 스크립트 경로 
            String pythonScriptPath = "src/main/java/com/doran/hardware/yolo8.py";
            
            // ProcessBuilder로 파이썬 스크립트 실행
            ProcessBuilder pb = new ProcessBuilder(pythonInterpreterPath, pythonScriptPath);
            pb.redirectErrorStream(true); // 표준 오류를 표준 출력으로 병합

            // 프로세스 시작
            Process process = pb.start();

            // 파이썬 스크립트의 출력을 읽음
            BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
            String line;
            while ((line = reader.readLine()) != null) {
                System.out.println(line);
            }

            // 프로세스 종료 상태 코드 확인
            int exitCode = process.waitFor();
            System.out.println("파이썬 스크립트가 종료되었습니다. 상태 코드: " + exitCode);
        } catch (IOException | InterruptedException e) {
            e.printStackTrace();
        }
    }
}
