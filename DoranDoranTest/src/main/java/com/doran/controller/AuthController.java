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

import com.doran.entity.ShipGroup;
import com.doran.entity.Ship;
import com.doran.mapper.AuthMapper;

// 그룹의 권한을 관리하고 수정/삭제하는 controller
@RequestMapping("/group")
@Controller
public class AuthController {

	@Autowired
	private AuthMapper authMapper;

	// 1. 선박번호로 그룹 멤버 리스트 가져오기
	@GetMapping("/list")
	public List<ShipGroup> groupList(String siCode) {

		List<ShipGroup> groupList = authMapper.groupList(siCode);
		return groupList;
	}

	// 2. 그룹 초대
	@PostMapping("/invite")
	public void invite(@RequestBody ShipGroup tbl_group) {

		tbl_group.setAuthNum(0);
		authMapper.invite(tbl_group);
	}

	// 3. 그룹 권한 수정(권한 부여)
	@PutMapping("/update")
	public String update(@RequestBody ShipGroup tbl_group, Ship tbl_ship, RedirectAttributes rttr) {

		if (topAuth(tbl_ship)) {

			authMapper.update(tbl_group);
		} else {

			rttr.addFlashAttribute("msgType", "실패");
			rttr.addFlashAttribute("msg", "회원 관리 권한이 없습니다.");
		}
		return "redirect:/";
	}

	// 4. 관리자 확인(로그인한 아이디가 선박 등록인과 일치하는지)
	public boolean topAuth(Ship tbl_ship) {

		Ship check = authMapper.topAuth(tbl_ship);

		if (check != null) {
			return true;
		} else
			return false;
	}

	// 5. 회원 삭제
	@DeleteMapping("/delete")
	public void delete(@RequestBody ShipGroup tbl_group, Ship tbl_ship, RedirectAttributes rttr) {

		if (topAuth(tbl_ship)) {

			authMapper.delete(tbl_group);
		} else {

			rttr.addFlashAttribute("msgType", "실패");
			rttr.addFlashAttribute("msg", "회원 삭제 권한이 없습니다.");
		}
	}
}
