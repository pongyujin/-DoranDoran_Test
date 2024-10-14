package com.doran.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.doran.entity.tbl_shipstat;
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

	@RequestMapping("/ship/statistics")
	public String showShipStatisticsPage(@RequestParam("siNum") int siNum, Model model) {
		
		// 입력받은 siNum을 기반으로 shipstat 정보를 조회
		tbl_shipstat shipstat = new tbl_shipstat();
		shipstat.setSiNum(siNum);

		// Mapper를 이용해서 데이터 조회
		tbl_shipstat result = shipstatMapper.shipstatSelect(shipstat);

		// 결과를 model에 담아서 JSP로 전달
		model.addAttribute("shipstat", result);

		return "ShipStatistics"; // ShipStatistics.jsp로 이동
	}

}
