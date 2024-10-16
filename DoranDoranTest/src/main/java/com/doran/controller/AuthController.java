package com.doran.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.doran.mapper.AuthMapper;
import com.doran.mapper.tbl_shipstatMapper;

@Controller
public class AuthController {

	@Autowired
	private AuthMapper authMapper;

	@GetMapping("")
	public String auth() {
		return ""; 
	}

}
