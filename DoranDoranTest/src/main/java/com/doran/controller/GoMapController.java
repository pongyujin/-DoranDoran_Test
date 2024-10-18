package com.doran.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class GoMapController {

	// map.jsp 이동
	@RequestMapping("/map")
	public String showMap() {
		return "map";
	}
}
