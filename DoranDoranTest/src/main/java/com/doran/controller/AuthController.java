package com.doran.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.doran.entity.Member;
import com.doran.entity.ShipGroup;
import com.doran.mapper.AuthMapper;

// 그룹의 권한을 관리하고 수정/삭제하는 controller
@RequestMapping("/group")
@Controller
public class AuthController {

	@Autowired
	private AuthMapper authMapper;

	// 0. 권한 확인(세션의 로그인 아이디 정보와 선박코드로 권한 번호 확인)
    @PostMapping("/authCheck")
	public int authCheck(ShipGroup shipGroup, HttpSession session) {

    	Member login = (Member) session.getAttribute("login");
    	shipGroup.setMemId(login.getMemId());
    	
		ShipGroup check = authMapper.authCheck(shipGroup);
		int authNum = check.getAuthNum();
		return authNum;
	}

	// 1. 선박번호로 그룹 멤버 리스트 가져오기
	@GetMapping("/list")
	public List<ShipGroup> groupList(String siCode) {

		List<ShipGroup> groupList = authMapper.groupList(siCode);
		return groupList;
	}

	// 2. 그룹 초대
	@PostMapping("/invite")
	public void invite(@RequestBody ShipGroup shipGroup, HttpSession session) {

		if(authCheck(shipGroup, session) == 0) {

			shipGroup.setAuthNum(0);
			authMapper.invite(shipGroup);
		}
	}

	// 3. 그룹 권한 수정(권한 부여)
	@PutMapping("/update")
	public String update(@RequestBody ShipGroup shipGroup, RedirectAttributes rttr, HttpSession session) {

		if(authCheck(shipGroup, session) == 0) {

			authMapper.update(shipGroup);
		} else {

			rttr.addFlashAttribute("msgType", "실패");
			rttr.addFlashAttribute("msg", "회원 관리 권한이 없습니다.");
		}
		return "redirect:/";
	}

	// 4. 회원 삭제
	@DeleteMapping("/delete")
	public void delete(@RequestBody ShipGroup shipGroup, RedirectAttributes rttr, HttpSession session) {

		if (authCheck(shipGroup, session) == 0) {

			authMapper.delete(shipGroup);
		} else {

			rttr.addFlashAttribute("msgType", "실패");
			rttr.addFlashAttribute("msg", "회원 삭제 권한이 없습니다.");
		}
	}
}
