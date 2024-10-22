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

	// map2.jsp 이동
	@RequestMapping("/map2")
	public String showMap2() {
		return "map2";
	}

	// map3.jsp 이동
	@RequestMapping("/map3")
	public String map3() {
		return "map3";
	}

	// videoModal.jsp 이동
	@RequestMapping("/videoModal")
	public String showVideoModal() {
		return "videoModal";
	}
}
