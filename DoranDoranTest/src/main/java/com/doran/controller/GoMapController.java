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

	// Controller.jsp 이동
	@RequestMapping("/map2")
	public String showController() {
		return "Controller";
	}

	// videoModal.jsp 이동
	@RequestMapping("/videoModal")
	public String showVideoModal() {
		return "videoModal";
	}
}
