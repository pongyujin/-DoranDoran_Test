package com.doran.hardware;

import com.jcraft.jsch.*;
import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;

public class RaspberrypiConnect {

    // SSH 연결 및 명령 실행 메서드
    public void cmdRemote(String user, String host, int port, String password, String command) {
        try {
            // SSH 세션 생성 및 설정
            JSch jsch = new JSch();
            Session session = jsch.getSession(user, host, port);
            session.setPassword(password);

            // SSH 연결 시 인증서 무시
            session.setConfig("StrictHostKeyChecking", "no");

            // SSH 연결
            session.connect();
            System.out.println("SSH 연결 성공");

            // 원격 명령 실행 (ChannelExec)
            ChannelExec channel = (ChannelExec) session.openChannel("exec");
            channel.setCommand(command);

            // 명령어 실행 결과를 읽기 위한 스트림 설정
            InputStream in = channel.getInputStream();
            channel.connect();

            // 명령어 출력 읽기
            BufferedReader reader = new BufferedReader(new InputStreamReader(in));
            String line;
            while ((line = reader.readLine()) != null) {
                System.out.println("명령어 결과: " + line);  // 자바 콘솔 창에 출력
            }

            // SSH 세션 종료
            channel.disconnect();
            session.disconnect();
            System.out.println("SSH 세션 종료.");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
