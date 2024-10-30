package com.doran.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.json.JSONObject;

@RestController
public class HwBatteryController {

	public double voltage;

	@RequestMapping(value = "/receive_voltage", method = RequestMethod.POST)
	public String receiveVoltage(@RequestBody String jsonData) {
		try {
			// JSON 파싱
			JSONObject json = new JSONObject(jsonData);
			voltage = json.getDouble("voltage");

			// 전압 데이터 출력
			System.out.println("Received voltage: " + voltage + " V");
			return "Voltage received successfully";

		} catch (Exception e) {
			e.printStackTrace();
			return "Error processing voltage data";
		}
	}

	// voltage의 getter 메서드
	public double getVoltage() {
		return voltage;
	}

}
