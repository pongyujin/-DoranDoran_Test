package com.doran.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.doran.entity.Waypoint;
import com.doran.mapper.tbl_shipstatMapper;

@RequestMapping("/statistics")
@RestController
public class ShipStatRestController {

	@Autowired
	private tbl_shipstatMapper shipstatMapper;

	// siNum이 없을 경우 기본값 1을 사용하도록 설정
	@GetMapping("/{siNum}")
	public Waypoint getShipStat(@PathVariable("siNum") int siNum) {
		System.out.println("넘어오긴함");
		System.out.println("번호 전송됨!!!!!!!!" + siNum);
		
		Waypoint stat = shipstatMapper.getShipStat(siNum);
		return stat; // 받은 siNum 값으로 데이터 조회
	}
}
