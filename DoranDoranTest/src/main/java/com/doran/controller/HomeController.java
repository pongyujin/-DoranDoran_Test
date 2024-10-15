package com.doran.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.doran.mapper.tbl_shipstatMapper;

@Controller
public class HomeController {

	@Autowired
	private tbl_shipstatMapper shipstatMapper;

	// 기본 홈 페이지
	@RequestMapping("/")
	public String main() {
		return "home";
	}

	// ShipStatistics.jsp 페이지로 이동
	@GetMapping("/ship/statistics")
	public String showShipStatisticsPage() {
		return "ShipStatistics"; // ShipStatistics.jsp 파일을 로드
	}

}
