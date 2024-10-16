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

import com.doran.entity.tbl_group;
import com.doran.entity.tbl_ship;
import com.doran.mapper.AuthMapper;

@RequestMapping("/group")
@Controller
public class AuthController {

	@Autowired
	private AuthMapper authMapper;

	// 1. 선박번호로 그룹 멤버 리스트 가져오기
	@GetMapping("/list")
	public List<tbl_group> groupList(String siCode) {

		List<tbl_group> groupList = authMapper.groupList(siCode);
		return groupList;
	}

	// 2. 그룹 초대
	@PostMapping("/invite")
	public void invite(@RequestBody tbl_group tbl_group) {

		tbl_group.setAuthNum(0);
		authMapper.invite(tbl_group);
	}

	// 3. 그룹 권한 수정(권한 부여)
	@PutMapping("/update")
	public String update(@RequestBody tbl_group tbl_group, tbl_ship tbl_ship, RedirectAttributes rttr) {

		if (topAuth(tbl_ship)) {

			authMapper.update(tbl_group);
		} else {

			rttr.addFlashAttribute("msgType", "실패");
			rttr.addFlashAttribute("msg", "회원 관리 권한이 없습니다.");
		}
		return "redirect:/";
	}

	// 4. 관리자 확인(로그인한 아이디가 선박 등록인과 일치하는지)
	public boolean topAuth(tbl_ship tbl_ship) {

		tbl_ship check = authMapper.topAuth(tbl_ship);

		if (check != null) {
			return true;
		} else
			return false;
	}

	// 5. 회원 삭제
	@DeleteMapping("/delete")
	public void delete(@RequestBody tbl_group tbl_group, tbl_ship tbl_ship, RedirectAttributes rttr) {

		if (topAuth(tbl_ship)) {

			authMapper.delete(tbl_group);
		} else {

			rttr.addFlashAttribute("msgType", "실패");
			rttr.addFlashAttribute("msg", "회원 삭제 권한이 없습니다.");
		}
	}
}
