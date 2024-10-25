package com.doran.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class GoMapController {

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

	// waypoint.jsp 이동
	@RequestMapping("/waypoint")
	public String waypoint() {
		return "waypoint";
	}

	// designation.jsp 이동
	@RequestMapping("/designation")
	public String designation() {
		return "designation";
	}
}
