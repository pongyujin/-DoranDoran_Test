package com.doran.hardware;

import com.jcraft.jsch.*;
import java.io.BufferedReader;
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
            
            // ssh 연결
            session.connect();

            // 원격 명령 실행 (ChannelExec)
            ChannelExec channel = (ChannelExec) session.openChannel("exec");
            channel.setCommand(command);

            // SSH 세션 종료
            channel.disconnect();
            session.disconnect();
            System.out.println("SSH 세션 종료.");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    
}