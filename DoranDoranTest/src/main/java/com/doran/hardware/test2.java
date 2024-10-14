package com.doran.hardware;

public class test2 {

	public static void main(String[] args) {

		// 라즈베리파이에 연결오류시 강종하는것!
		RaspberrypiConnect rp = new RaspberrypiConnect();
		// 초기값
		String user = "xo";
		String host = "192.168.219.47";
		int port = 22;
		String password = "xo";
		String command = "pkill -f finala_server_boat_up1.py";
		rp.cmdRemote(user, host, port, password, command);

	}

}
