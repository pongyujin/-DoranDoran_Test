package com.doran.controller;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ExecutionException;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

@RestController
public class WeatherController {

	private final RestTemplate restTemplate;

	public WeatherController(RestTemplate restTemplate) {
		this.restTemplate = restTemplate;
	}

	// 1. 해양 수산부 api 요청 메서드
	@GetMapping("/weather")
	public ResponseEntity<WeatherResponse> getWeatherData() throws ExecutionException, InterruptedException {
		String serviceKey = "bvd0WcsuRPzcUhhu82GPw==";

		// 현재 날짜 불러오기
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMdd");
		String currentDate = LocalDate.now().format(formatter);
		System.out.println(currentDate);
		List<CompletableFuture<Object>> futures = new ArrayList<>();

		futures.add(fetchData("tideObs", serviceKey, "DT_0007", currentDate));
		futures.add(fetchData("obsWaveHight", serviceKey, "TW_0062", currentDate));
		futures.add(fetchData("fcTidalCurrent", serviceKey, "16LTC05", currentDate));
		futures.add(fetchData("tidalHfRadar", serviceKey, "HF_0074", currentDate));
		futures.add(fetchData("tideObsTemp", serviceKey, "DT_0007", currentDate));
		futures.add(fetchData("tideObsAirTemp", serviceKey, "DT_0007", currentDate));
		futures.add(fetchData("tideObsAirPres", serviceKey, "DT_0007", currentDate));
		futures.add(fetchData("tideObsWind", serviceKey, "DT_0007", currentDate));
		futures.add(fetchData("seafogReal", serviceKey, "SF_0007", currentDate));

		// 모든 CompletableFuture가 완료될 때까지 기다림
		CompletableFuture<Void> allFutures = CompletableFuture.allOf(futures.toArray(new CompletableFuture[0]));
		allFutures.get(); // Blocking until all are done

		// 결과를 수집
		WeatherResponse response = new WeatherResponse();
		response.setTideObs(futures.get(0).get());
		response.setObsWaveHight(futures.get(1).get());
		response.setFcTidalCurrent(futures.get(2).get());
		response.setTidalHfRadar(futures.get(3).get());
		response.setTideObsTemp(futures.get(4).get());
		response.setTideObsAirTemp(futures.get(5).get());
		response.setTideObsAirPres(futures.get(6).get());
		response.setTideObsWind(futures.get(7).get());
		response.setSeafogReal(futures.get(8).get());
		System.out.println(response.getTideObs());

		return ResponseEntity.ok(response);
	}

	// 2.
	private CompletableFuture<Object> fetchData(String type, String serviceKey, String obsCode, String date) {
		String url = String.format(
				"http://www.khoa.go.kr/api/oceangrid/%s/search.do?ServiceKey=%s&ObsCode=%s&Date=%s&ResultType=json",
				type, serviceKey, obsCode, date);
		return CompletableFuture.supplyAsync(() -> restTemplate.getForObject(url, Object.class));
	}

	// JSON 데이터에서 정보 추출 함수 (예시로 특정 필드 반환)
	private Object extractInfo(Object jsonData, String fieldName) {
		// JSON 데이터에서 정보를 추출하는 로직을 구현하세요.
		// 예시: JsonNode를 사용하여 특정 필드 값을 가져오는 방식
		// (Jackson 라이브러리 사용 시)
		return null; // 수정 필요
	}

	// 4. Response 클래스
	public static class WeatherResponse {
		private Object tideObs;
		private Object obsWaveHight;
		private Object fcTidalCurrent;
		private Object tidalHfRadar;
		private Object tideObsTemp;
		private Object tideObsAirTemp;
		private Object tideObsAirPres;
		private Object tideObsWind;
		private Object seafogReal;

		// Getters and Setters
		public Object getTideObs() {
			return tideObs;
		}

		public void setTideObs(Object tideObs) {
			this.tideObs = tideObs;
		}

		public Object getObsWaveHight() {
			return obsWaveHight;
		}

		public void setObsWaveHight(Object obsWaveHight) {
			this.obsWaveHight = obsWaveHight;
		}

		public Object getFcTidalCurrent() {
			return fcTidalCurrent;
		}

		public void setFcTidalCurrent(Object fcTidalCurrent) {
			this.fcTidalCurrent = fcTidalCurrent;
		}

		public Object getTidalHfRadar() {
			return tidalHfRadar;
		}

		public void setTidalHfRadar(Object tidalHfRadar) {
			this.tidalHfRadar = tidalHfRadar;
		}

		public Object getTideObsTemp() {
			return tideObsTemp;
		}

		public void setTideObsTemp(Object tideObsTemp) {
			this.tideObsTemp = tideObsTemp;
		}

		public Object getTideObsAirTemp() {
			return tideObsAirTemp;
		}

		public void setTideObsAirTemp(Object tideObsAirTemp) {
			this.tideObsAirTemp = tideObsAirTemp;
		}

		public Object getTideObsAirPres() {
			return tideObsAirPres;
		}

		public void setTideObsAirPres(Object tideObsAirPres) {
			this.tideObsAirPres = tideObsAirPres;
		}

		public Object getTideObsWind() {
			return tideObsWind;
		}

		public void setTideObsWind(Object tideObsWind) {
			this.tideObsWind = tideObsWind;
		}

		public Object getSeafogReal() {
			return seafogReal;
		}

		public void setSeafogReal(Object seafogReal) {
			this.seafogReal = seafogReal;
		}

	}

}