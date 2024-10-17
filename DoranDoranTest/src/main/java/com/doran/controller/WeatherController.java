package com.doran.controller;

import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

import com.doran.entity.Weather;
import com.doran.mapper.WeatherMapper;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

@RestController
public class WeatherController {

	@Autowired
	private WeatherMapper weatherMapper;
	@Autowired
	private RestTemplate restTemplate;

	private final String serviceKey = "bvd0WcsuRPzcUhhu82GPw==";

	// 현재 날짜 불러오기
	DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMdd");
	String currentDate = LocalDate.now().format(formatter);
	// - 하이픈이 들어간 현재 날짜 포매팅
	DateTimeFormatter barformatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
	String barcurrentDate = LocalDate.now().format(barformatter);

	// 현재 시간 가져오기
	DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm:00");
	String currentTime = LocalTime.now().minusMinutes(10).format(timeFormatter); // 5분 빼기

	// 0. 전체 정보 조회
	@SuppressWarnings("null")
	@GetMapping("/weather")
	public Weather weather() {

		Weather weather = null;

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

	// 0. json 파싱
	public String weatherParsing(String response, String what) {

		// JSON 파싱
		ObjectMapper objectMapper = new ObjectMapper();
		try {
			JsonNode jsonNode = objectMapper.readTree(response);
			JsonNode dataNode = jsonNode.path("result").path("data");

			String whatResult = null;
			String RecordTime = null;
			System.out.println(this.barcurrentDate + " " + this.currentTime);

			for (JsonNode node : dataNode) {
				String recordTime = node.path("record_time").asText();
				if (recordTime.equals(this.barcurrentDate + " " + this.currentTime)) {
					whatResult = node.path(what).asText();
					RecordTime = recordTime;
					break; // 일치하는 데이터 찾으면 종료
				}
			}

			if (whatResult != null && RecordTime != null) {

				return String.format(what + ": %s, record_time: %s", whatResult, RecordTime);
			} else {
				System.out.println("No matching data found.");
			}
			return "";
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "";
	}

	// 1. 조위 (완)
	@GetMapping("/tideObs")
	public String tideObs() {

		String url = String.format(
				"http://www.khoa.go.kr/api/oceangrid/tideObs/search.do?ServiceKey=%s&ObsCode=%s&Date=%s&ResultType=json",
				this.serviceKey, "DT_0007", this.currentDate);

		// API 요청
		String response = restTemplate.getForObject(url, String.class);
		String result = weatherParsing(response, "tide_level");

		return result;
	}

	// 2. 파고 (보류 - 형식다름)
	@GetMapping("/obsWaveHight")
	public String obsWaveHight() {

		String url = String.format(
				"http://www.khoa.go.kr/api/oceangrid/obsWaveHight/search.do?ServiceKey=%s&ObsCode=%s&Date=%s&ResultType=json",
				this.serviceKey, "DT_0042", this.currentDate);

		// API 요청
		String response = restTemplate.getForObject(url, String.class);
		return response;
	}

	// 3. 조류 (보류 - 형식다름)(dto에 없음)
	@GetMapping("/fcTidalCurrent")
	public String fcTidalCurrent() {

		String url = String.format(
				"http://www.khoa.go.kr/api/oceangrid/fcTidalCurrent/search.do?ServiceKey=%s&ObsCode=%s&Date=%s&ResultType=json",
				this.serviceKey, "01MP-2", this.currentDate);

		// API 요청
		String response = restTemplate.getForObject(url, String.class);
		return response;
	}

	// 4. 수온 (완)
	@GetMapping("/tideObsTemp")
	public String tideObsTemp() {

		String url = String.format(
				"http://www.khoa.go.kr/api/oceangrid/tideObsTemp/search.do?ServiceKey=%s&ObsCode=%s&Date=%s&ResultType=json",
				this.serviceKey, "DT_0007", this.currentDate);

		// API 요청
		String response = restTemplate.getForObject(url, String.class);
		String result = weatherParsing(response, "water_temp");

		return result;
	}

	// 5. 기온 (완)
	@GetMapping("/tideObsAirTemp")
	public String tideObsAirTemp() {

		String url = String.format(
				"http://www.khoa.go.kr/api/oceangrid/tideObsAirTemp/search.do?ServiceKey=%s&ObsCode=%s&Date=%s&ResultType=json",
				this.serviceKey, "DT_0007", this.currentDate);

		// API 요청
		String response = restTemplate.getForObject(url, String.class);
		String result = weatherParsing(response, "air_temp");

		return result;
	}

	// 6. 기압 (완, 이긴한데 변수있음 00:01분 부터 3분 단위인것같아)
	@GetMapping("/tideObsAirPres")
	public String tideObsAirPres() {

		String url = String.format(
				"http://www.khoa.go.kr/api/oceangrid/tideObsAirPres/search.do?ServiceKey=%s&ObsCode=%s&Date=%s&ResultType=json",
				this.serviceKey, "DT_0007", this.currentDate);

		// API 요청
		String response = restTemplate.getForObject(url, String.class);
		String result = weatherParsing(response, "air_pres");

		return response;
	}

	// 7. 풍향/풍속 (완 - 형식다름)
	@GetMapping("/tideObsWind")
	public String tideObsWind() {

		String url = String.format(
				"http://www.khoa.go.kr/api/oceangrid/tideObsWind/search.do?ServiceKey=%s&ObsCode=%s&Date=%s&ResultType=json",
				this.serviceKey, "DT_0007", this.currentDate);

		// API 요청
		String response = restTemplate.getForObject(url, String.class);

		// JSON 파싱
		ObjectMapper objectMapper = new ObjectMapper();
		try {
			JsonNode jsonNode = objectMapper.readTree(response);
			JsonNode dataNode = jsonNode.path("result").path("data");

			String windDir = null;
			String windSpeed = null;
			String RecordTime = null;
			System.out.println(this.barcurrentDate + " " + this.currentTime);

			for (JsonNode node : dataNode) {
				String recordTime = node.path("record_time").asText();
				if (recordTime.equals(this.barcurrentDate + " " + this.currentTime)) {
					windDir = node.path("wind_dir").asText();
					windSpeed = node.path("wind_speed").asText();
					RecordTime = recordTime;
					break; // 일치하는 데이터 찾으면 종료
				}
			}

			if (windDir != null && windSpeed != null && RecordTime != null) {

				return String.format("wind_dir : %s, wind_speed : %s, record_time: %s", windDir, windSpeed, RecordTime);
			} else {
				return "No matching data found.";
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

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