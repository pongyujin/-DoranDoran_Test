package com.doran.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

import com.doran.entity.Coordinate;

// 구글 api로 지도 및 경로를 표시하는 controller
@RestController
public class GoogleMapController {

	private final String apiKey = "AIzaSyDtt1tmfQ-lTeQaCimRBn2PQPTlCLRO6Pg";
	private final String placeKey = "AIzaSyAW9QwdMPgIykOFaLdCX5ZJTQOED8FVLfg";

	// 1. 구글 마커 표시 api
	@GetMapping("/marker")
	public String getLocationInfo(@RequestParam double latitude, @RequestParam double longitude) {
		RestTemplate restTemplate = new RestTemplate();

		String url = String.format("https://maps.googleapis.com/maps/api/geocode/json?latlng=%s,%s&language=ko&key=%s",
				latitude, longitude, apiKey);

		String response = restTemplate.getForObject(url, String.class);
		return response; // JSON 응답을 반환합니다.
	}

	// 2. a* 경로 좌표 리스트 변환(문자열 정보를 api에 쓸 수 있는 json 형태로)
	@GetMapping("/flightPlanCoordinates")
	public List<Coordinate> flightPlanCoordinates(String coordinateData) {

		// 변환된 좌표를 저장할 리스트
		List<Coordinate> flightPlanCoordinates = new ArrayList<>();

		// 정규 표현식 패턴 (위도와 경도를 추출하는 패턴)
		Pattern pattern = Pattern.compile("위도: ([\\d.]+), 경도: ([\\d.]+)");

		// 줄바꿈으로 데이터를 분리 (줄 단위로 나누기)
		String[] lines = coordinateData.split("\\r?\\n");

		// 데이터를 변환하는 반복문
		for (String data : lines) {
			Matcher matcher = pattern.matcher(data);

			if (matcher.find()) {
				double lat = Double.parseDouble(matcher.group(1)); // 위도 추출
				double lng = Double.parseDouble(matcher.group(2)); // 경도 추출

				// 변환된 좌표 객체를 리스트에 추가
				flightPlanCoordinates.add(new Coordinate(lat, lng));
			}
		}
		return flightPlanCoordinates;
	}
}
