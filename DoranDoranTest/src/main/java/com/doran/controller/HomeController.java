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

	// 나는야 통계페이지
	@RequestMapping("/statistics")
	public String statistics() {
		return "ShipStatistics";
	}

	// 암
	@GetMapping("/main")
	public String showMainPage() {
		return "Main";

	}
	 // Manager 페이지 추가
    @GetMapping("/manager")
    public String showManagerPage() {
        return "Manager";  
    }
}


