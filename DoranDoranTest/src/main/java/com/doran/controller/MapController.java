package com.doran.controller;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class MapController {

	@GetMapping("/map")
	public String showMap(Model model) {
		return "map"; // home.jsp로 이동
	}

}
