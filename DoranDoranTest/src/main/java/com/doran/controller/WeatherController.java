package com.doran.controller;

import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

import com.doran.entity.tbl_weather;
import com.doran.mapper.WeatherMapper;

@RestController
public class WeatherController {

	@Autowired
	private WeatherMapper weatherMapper;
	@Autowired
	private RestTemplate restTemplate;

	private String serviceKey = "bvd0WcsuRPzcUhhu82GPw==";

	// 현재 날짜 불러오기
	DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMdd");
	String currentDate = LocalDate.now().format(formatter);
	// 현재 시간 가져오기
	DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm");
	String currentTime = LocalTime.now().format(timeFormatter);
	
	// 0. 전체 정보 조회
	@SuppressWarnings("null")
	@GetMapping("/weather")
	public tbl_weather weather() {
		
		tbl_weather weather = null;
		
		weather.setWDate(currentDate);
		weather.setWTime(currentTime);
		weather.setWTemp(0);
		weather.setWWindSpeed(0);
		weather.setWWaveHeight(0);
		weather.setWSeaTemp(0);
		weather.setWRegion("DT_0007");
		weather.setSailNum(0);
		weather.setSiCode(currentDate);
		weatherMapper.insertWeather(weather);
		
		return weather;
	}

	// 1. 조위
	@GetMapping("/tideObs")
	public String tideObs() {

		String url = String.format(
				"http://www.khoa.go.kr/api/oceangrid/tideObs/search.do?ServiceKey=%s&ObsCode=%s&Date=%s&ResultType=json",
				this.serviceKey, "DT_0007", this.currentDate);

		// API 요청
		String response = restTemplate.getForObject(url, String.class);
		return response;
	}

	// 2. 파고
	@GetMapping("/obsWaveHight")
	public String obsWaveHight() {

		String url = String.format(
				"http://www.khoa.go.kr/api/oceangrid/obsWaveHight/search.do?ServiceKey=%s&ObsCode=%s&Date=%s&ResultType=json",
				this.serviceKey, "DT_0042", this.currentDate);

		// API 요청
		String response = restTemplate.getForObject(url, String.class);
		return response;
	}

	// 3. 조류
	@GetMapping("/fcTidalCurrent")
	public String fcTidalCurrent() {

		String url = String.format(
				"http://www.khoa.go.kr/api/oceangrid/fcTidalCurrent/search.do?ServiceKey=%s&ObsCode=%s&Date=%s&ResultType=json",
				this.serviceKey, "01MP-2", this.currentDate);

		// API 요청
		String response = restTemplate.getForObject(url, String.class);
		return response;
	}

	// 4. 수온
	@GetMapping("/tideObsTemp")
	public String tideObsTemp() {

		String url = String.format(
				"http://www.khoa.go.kr/api/oceangrid/tideObsTemp/search.do?ServiceKey=%s&ObsCode=%s&Date=%s&ResultType=json",
				this.serviceKey, "DT_0007", this.currentDate);

		// API 요청
		String response = restTemplate.getForObject(url, String.class);
		return response;
	}

	// 5. 기온
	@GetMapping("/tideObsAirTemp")
	public String tideObsAirTemp() {

		String url = String.format(
				"http://www.khoa.go.kr/api/oceangrid/tideObsAirTemp/search.do?ServiceKey=%s&ObsCode=%s&Date=%s&ResultType=json",
				this.serviceKey, "DT_0007", this.currentDate);

		// API 요청
		String response = restTemplate.getForObject(url, String.class);
		return response;
	}

	// 6. 기압
	@GetMapping("/tideObsAirPres")
	public String tideObsAirPres() {

		String url = String.format(
				"http://www.khoa.go.kr/api/oceangrid/tideObsAirPres/search.do?ServiceKey=%s&ObsCode=%s&Date=%s&ResultType=json",
				this.serviceKey, "DT_0007", this.currentDate);

		// API 요청
		String response = restTemplate.getForObject(url, String.class);
		return response;
	}

	// 7. 풍향/풍속
	@GetMapping("/tideObsWind")
	public String tideObsWind() {

		String url = String.format(
				"http://www.khoa.go.kr/api/oceangrid/tideObsWind/search.do?ServiceKey=%s&ObsCode=%s&Date=%s&ResultType=json",
				this.serviceKey, "DT_0007", this.currentDate);

		// API 요청
		String response = restTemplate.getForObject(url, String.class);
		return response;
	}

	// 8. 해무
	@GetMapping("/seafogReal")
	public String seafogReal() {

		String url = String.format(
				"http://www.khoa.go.kr/api/oceangrid/seafogReal/search.do?ServiceKey=%s&ObsCode=%s&Date=%s&ResultType=json",
				this.serviceKey, "SF_0007", this.currentDate);

		// API 요청
		String response = restTemplate.getForObject(url, String.class);
		return response;
	}

}