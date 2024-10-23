package com.doran.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class InfoPanelController {
	
	@Autowired
	private WeatherController weatherController;

	// 1. infoTitle에 따라 정보받아오는 함수 실행
	@GetMapping(value = "/getInfo", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getInfo(@RequestParam String infoTitle) {

		String result = "";

		switch (infoTitle) {
		case "날씨":
			result = weather();
			break;
		case "온도":
			result = temperature();
			break;
		case "배터리":
			result = battery();
			break;
		case "통신 상태":
			result = signalStatus();
			break;
		case "속도":
			result = velocity();
			break;
		case "남은 시간":
			result = remainTime();
			break;
		case "남은 거리":
			result = remainDistance();
			break;
		case "현재 위치":
			result = location();
			break;
		case "방위":
			result = direction();
			break;
		case "주변 장애물 탐지":
			result = obstacle();
			break;
		default:
			result = "Invalid request"; // 유효하지 않은 경우 처리
			break;
		}
		return result;
	}

	// 2. 날씨
	public String weather() {
		
		String weather = "12 kn, SW(241°), 23°C";
		return weather;
	}

	// 3. 온도
	public String temperature() {
		
		String temperature = weatherController.tideObsAirTemp()+"°C 입니다";
		return temperature;
	}

	// 4. 배터리
	public String battery() {
		
		String battery = "배터리 잔량 " + 80 + "%";
		return battery;
	}

	// 5. 통신 상태
	public String signalStatus() {
		
		String signalStatus = "통신 상태 " + "양호";
		return signalStatus;
	}

	// 6. 속도
	public String velocity() {
		
		String velocity = 30 + " 노트 속도";
		return velocity;
	}

	// 7. 남은 시간
	public String remainTime() {
		
		String remainTime = "남은 시간 " + 2 + "시간";
		return remainTime;
	}

	// 8. 남은 거리
	public String remainDistance() {
		
		String remainDistance = "남은 거리 " + 10 + "km";
		return remainDistance;
	}

	// 9. 현재 위치
	public String location() {
		
		String location = "위도: " + 37.5665 + ", 경도: " + 126.9780;
		return location;
	}

	// 10. 방위
	public String direction() {
		
		String direction = "방위각 " + 90;
		return direction;
	}

	// 11. 주변 장애물 탐지
	public String obstacle() {

		String obstacle = "장애물 없음";
		return obstacle;
	}

}
