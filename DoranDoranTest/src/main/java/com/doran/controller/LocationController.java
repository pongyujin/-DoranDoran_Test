package com.doran.controller;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.Arrays;
import java.util.List;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;
import org.springframework.web.util.UriUtils;

import com.doran.entity.Coordinate;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

@RestController
public class LocationController {

	private final String apiKey = "AIzaSyDtt1tmfQ-lTeQaCimRBn2PQPTlCLRO6Pg";

	// 1. 구글 마커 표시 api
	@GetMapping("/marker")
	public String getLocationInfo(@RequestParam double latitude, @RequestParam double longitude) {
		RestTemplate restTemplate = new RestTemplate();

		String url = String.format("https://maps.googleapis.com/maps/api/geocode/json?latlng=%s,%s&language=ko&key=%s",
				latitude, longitude, apiKey);

		String response = restTemplate.getForObject(url, String.class);
		return response; // JSON 응답을 반환합니다.
	}

	// 2. a* 경로 지도에 표시하도록 좌표리스트 반환
	@GetMapping("/course")
	public List<Coordinate> getFlightPlanCoordinates() {

		return Arrays.asList(new Coordinate(37.267409, 127.033628), new Coordinate(37.288332, 127.012152),
				new Coordinate(37.314092, 126.949152), new Coordinate(37.275035, 126.942629),
				new Coordinate(37.253723, 126.916879));
	}

	// 3. geocoding api
	@PostMapping("/geocode")
	public String geocode(@RequestParam String address) throws UnsupportedEncodingException {

		String GEOCODING_API_URL = "https://maps.googleapis.com/maps/api/geocode/json";
		
		address = new String(address.getBytes("ISO-8859-1"), "UTF-8");
		System.out.println(address);
		
		// Geocoding API 호출 URL 생성
		String url = UriComponentsBuilder.fromHttpUrl(GEOCODING_API_URL).queryParam("address", address)
				.queryParam("language", "ko").queryParam("key", apiKey).toUriString();

		System.out.println(url);
		
		RestTemplate restTemplate = new RestTemplate();
		String jsonResponse = restTemplate.getForObject(url, String.class); // JSON 문자열로 응답 받기

		// JSON 파싱
		try {
			ObjectMapper objectMapper = new ObjectMapper();
			JsonNode rootNode = objectMapper.readTree(jsonResponse);
			String status = rootNode.path("status").asText();

			// status가 OK인지 확인
			if ("OK".equals(status)) {
				JsonNode location = rootNode.path("results").get(0).path("geometry").path("location");
				double lat = location.path("lat").asDouble();
				double lng = location.path("lng").asDouble();
				System.out.println(lat);
				System.out.println(lng);

				return ""; // 위도와 경도를 배열로 반환
			} else {
				// 오류 처리 (예: "ZERO_RESULTS")
				return "ZERO_RESULTS"; // 필요한 경우 적절한 반환 값 설정
			}
		} catch (Exception e) {
			e.printStackTrace(); // 오류 로그 출력
			return "error"; // 오류 발생 시 반환 값
		}
	}
}
