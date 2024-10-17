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

import com.doran.entity.Coordinate;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

@RestController
public class LocationController {

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
		String placeId = placeId(address); // 주소로 장소 ID 반환받기

		// Geocoding API 호출 URL 생성
		String url = UriComponentsBuilder.fromHttpUrl(GEOCODING_API_URL)
				.queryParam("place_id", "ChIJq8zBMx67czUREGThCetMcGI").queryParam("key", apiKey).toUriString();

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

				return String.format("Latitude: %s, Longitude: %s", lat, lng);// 위도와 경도를 배열로 반환
			} else {
				// 오류 처리 (api 검색 결과가 없는 경우)
				return "ZERO_RESULTS"; // 필요한 경우 적절한 반환 값 설정
			}
		} catch (Exception e) {
			e.printStackTrace();
			return "error";
		}
	}

	// 4. 구글 장소 ID 반환 메서드
	@PostMapping("/placeId")
	public String placeId(String address) throws UnsupportedEncodingException {

		// 주소를 URL 인코딩
		address = new String(address.getBytes("ISO-8859-1"), "UTF-8");
		System.out.println("Encoded Address: " + address);

		// Places API 호출 URL 생성
		String url = UriComponentsBuilder
				.fromHttpUrl("https://maps.googleapis.com/maps/api/place/findplacefromtext/json")
				.queryParam("input", address)
				.queryParam("inputtype", "textquery")
				.queryParam("language", "ko")
				.queryParam("region", "KR")
				.queryParam("fields", "place_id")
				.queryParam("key", placeKey)
				.toUriString();

		System.out.println("API URL: " + url);

		RestTemplate restTemplate = new RestTemplate();

		// JSON 파싱
		try {
			String jsonResponse = restTemplate.getForObject(url, String.class); // JSON 문자열로 응답 받기
			System.out.println("JSON Response: " + jsonResponse); // 응답 로그 출력

			ObjectMapper objectMapper = new ObjectMapper();
			JsonNode rootNode = objectMapper.readTree(jsonResponse);
			String status = rootNode.path("status").asText();

			// status가 OK인지 확인
			if ("OK".equals(status)) {
				JsonNode candidates = rootNode.path("candidates");
				if (candidates.isArray() && candidates.size() > 0) {
					String placeId = candidates.get(0).path("place_id").asText();
					System.out.println("Place ID: " + placeId);
					return placeId; // 장소 ID 반환
				} else {
					return "NO_RESULTS"; // 장소가 없을 경우
				}
			} else {
				System.out.println("Error Status: " + status); // 에러 상태 출력
				return status; // 필요한 경우 적절한 반환 값 설정
			}
		} catch (Exception e) {
			e.printStackTrace(); // 오류 로그 출력
			return "error"; // 오류 발생 시 반환 값
		}
	}
}
