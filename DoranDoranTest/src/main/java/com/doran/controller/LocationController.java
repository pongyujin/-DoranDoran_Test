package com.doran.controller;

import java.util.Arrays;
import java.util.List;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

import com.doran.entity.Coordinate;

@RestController
public class LocationController {

	// map.jsp 이동
	@GetMapping("/map")
	public String showMap() {
		return "map";
	}

	// 1. 구글 마커 표시 api
	@GetMapping("/marker")
	public String getLocationInfo(@RequestParam double latitude, @RequestParam double longitude) {
		RestTemplate restTemplate = new RestTemplate();

		String apiKey = "AIzaSyAW9QwdMPgIykOFaLdCX5ZJTQOED8FVLfg"; // API 키를 설정하세요.
		String url = String.format("https://maps.googleapis.com/maps/api/geocode/json?latlng=%s,%s&language=ko&key=%s",
				latitude, longitude, apiKey);

		String response = restTemplate.getForObject(url, String.class);
		return response; // JSON 응답을 반환합니다.
	}
	
	// 2. a* 경로 지도에 표시하도록 좌표리스트 반환
	@GetMapping("/course")
    public List<Coordinate> getFlightPlanCoordinates() {
		
        return Arrays.asList(
            new Coordinate(37.772, -122.214),
            new Coordinate(21.291, -157.821),
            new Coordinate(-18.142, 178.431),
            new Coordinate(-27.467, 153.027)
        );
    }
}
