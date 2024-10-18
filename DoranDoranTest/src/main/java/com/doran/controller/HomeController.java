package com.doran.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

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
}
