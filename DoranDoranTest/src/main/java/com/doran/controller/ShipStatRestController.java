package com.doran.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.doran.entity.Gps;
import com.doran.entity.Weather;
import com.doran.mapper.GpsMapper;
import com.doran.mapper.WeatherMapper;

@RequestMapping("/statistics")
@RestController
public class ShipStatRestController {

	@Autowired
	private GpsMapper gpsmapper;
	private WeatherMapper weathermapper;

	
	// siNum이 없을 경우 기본값 1을 사용하도록 설정
	@GetMapping("/{sailNum}")
	public List<Gps> getShipStat(@PathVariable("sailNum") int sailNum) {
		// 1. 선박번호로 Gps 데이터 가져오는 메서드
		System.out.println("넘어오긴함");
		System.out.println("번호 전송됨!!!!!!!!" + sailNum);
		
		List<Gps> gpsList= gpsmapper.getGps(sailNum);
		System.out.println("gpsList : "+ gpsList);
		
		//List<Weather>= weathermapper.weatherList(siCode,sailNum);

		return gpsList; // 받은 siNum 값으로 데이터 조회
	}
	
	// 2. 날씨+배터리 데이터 가져오는 메서드
	
}
