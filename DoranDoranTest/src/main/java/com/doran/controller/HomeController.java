package com.doran.controller;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class HomeController {
	
    @Value("${GOOGLE_CLIENT_ID}")
    private String googleClientId;
	

	// 기본 홈 페이지
	@RequestMapping("/")
	public String main() {
		return "home";
	}

	// 통계 페이지로 이동 (권한 확인 불필요)
	@GetMapping("/statistics")
	public String showStatisticsPage(@RequestParam String siCode, Model model) {
	    // siCode를 전달하여 통계 페이지에서 사용할 수 있도록 설정
	    model.addAttribute("siCode", siCode);

	    return "ShipStatistics"; // ShipStatistics.jsp로 이동
	}

	// 메인 페이지 이동
	@GetMapping("/main")
	public String showMainPage(Model model) {
		System.out.println("야옹"+googleClientId);
		
		model.addAttribute("googleClientId", googleClientId);
		return "Main";

	}

	// Manager 관리자 페이지 추가
	@GetMapping("/manager")
	public String showManagerPage() {
		return "Manager";
	}
	
	// motorControlTest.jsp 이동 (수동제어 테스트용입니당)
	@GetMapping("/motorControlTest")
	public String motorControlTestPage() {
		return "motorControlTest";
	}
}
