package com.doran.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class HomeController {

	// 기본 홈 페이지
	@RequestMapping("/")
	public String main() {
		return "home";
	}

	@RequestMapping("/statistics")
	public String statistics() {
		return "ShipStatistics";
	}

	@GetMapping("/main")
	public String showMainPage() {
		return "Main";

	}
	
	// hardware.jsp로 이동
	@RequestMapping("/hardware")
	public String showHardwarePage() {
		return "hardware";
	}
	
	// sailViewTest.jsp로 이동
	@RequestMapping("/realTimeCamera")
	public String showSailViewTestPage() {
		return "realTimeCamera";
	}
}
