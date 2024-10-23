package com.doran.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.doran.entity.Member;
import com.doran.entity.Ship;
import com.doran.entity.ShipGroup;
import com.doran.mapper.ShipGroupMapper;
import com.doran.mapper.ShipMapper;

// 그룹의 권한을 관리하고 수정/삭제하는 controller
@Controller
public class ShipGroupController {

	@Autowired
	private ShipGroupMapper shipgroupMapper;

	@Autowired
	private ShipMapper shipMapper;

	// 0. 그룹 내 권한 확인 (로그 추가)
	@PostMapping("/authCheck")
	public @ResponseBody int authCheck(@RequestBody ShipGroup shipGroup, HttpSession session) {
		Member login = (Member) session.getAttribute("user");

		System.out.println("authCheck - 로그인된 사용자: " + login);

		if (login == null) {
			System.out.println("authCheck - 로그인되지 않은 사용자입니다.");
			return -1; // 로그인되지 않은 상태
		}

		shipGroup.setMemId(login.getMemId());
		ShipGroup check = shipgroupMapper.authCheck(shipGroup);

		if (check == null) {
			System.out.println("authCheck - 그룹에 속하지 않은 사용자입니다.");
			return -2; // 해당 그룹에 없는 경우
		}

		System.out.println("authCheck - 권한 번호: " + check.getAuthNum());
		return check.getAuthNum(); // 권한 번호 반환
	}

	// 1. 선박번호로 그룹 멤버 리스트 가져오기
	@RequestMapping("/grouplist")
	public @ResponseBody List<ShipGroup> groupList(String siCode) {
		List<ShipGroup> groupList = shipgroupMapper.groupList(siCode);
		System.out.println("ShipGroupController : " + groupList);
		return groupList;
	}

	// 소유자 확인 후 그룹에 속하지 않으면 권한을 0으로 설정
	@PostMapping("/groupinvite")
	public ResponseEntity<String> invite(@RequestBody ShipGroup shipGroup, HttpSession session) {
		// 로그인된 사용자 정보 확인
		Member login = (Member) session.getAttribute("user");

		if (login == null) {
			System.out.println("로그인된 사용자가 없습니다.");
			return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("로그인이 필요합니다.");
		}

		// 초대된 사용자에게 소유자 확인 및 권한 설정
		Ship ownerShip = shipMapper.findShipBySiCode(shipGroup.getSiCode());

		if (ownerShip == null) {
			System.out.println("해당 siCode로 조회된 선박이 없습니다.");
			return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("해당 선박이 존재하지 않습니다.");
		}

		// 이미 그룹에 속한 사용자인지 확인
		ShipGroup existingMember = shipgroupMapper.findMemberInGroup(shipGroup);
		if (existingMember != null) {
			System.out.println("해당 사용자는 이미 그룹에 속해 있습니다.");
			return ResponseEntity.status(HttpStatus.CONFLICT).body("해당 사용자는 이미 그룹에 속해 있습니다.");
		}

		// 현재 로그인된 사용자가 소유자인지 확인
		if (ownerShip.getMemId().equals(login.getMemId())) {
			System.out.println("초대된 사용자는 소유자입니다. 관리자로 권한 설정.");
			shipGroup.setAuthNum(0); // 관리자로 설정
		}

		// 그룹에 사용자 초대
		int cnt = shipgroupMapper.invite(shipGroup);
		// 초대 성공 시 응답
		if (cnt > 0) {
			return ResponseEntity.ok("초대 성공");
		} else {
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("초대 실패");
		}
	}

	// 선박 소유자 확인 (로그 추가)
	@PostMapping("/checkOwnership")
	public @ResponseBody boolean checkOwnership(@RequestBody Map<String, String> request, HttpSession session) {
		Member login = (Member) session.getAttribute("user");

		System.out.println("checkOwnership - 로그인된 사용자: " + login);

		if (login == null) {
			System.out.println("checkOwnership - 로그인되지 않은 사용자입니다.");
			return false;
		}

		String siCode = request.get("siCode");
		System.out.println("checkOwnership - 전달된 siCode: " + siCode);

		Ship ship = shipMapper.findShipBySiCode(siCode);

		if (ship == null) {
			System.out.println("checkOwnership - 해당 siCode로 조회된 선박이 없습니다.");
			return false;
		}

		System.out.println("checkOwnership - 소유자 정보: " + ship.getMemId());
		return ship.getMemId().equals(login.getMemId());
	}

	// 3. 그룹 권한 수정(권한 부여)
	@PutMapping("/groupupdate")
	public String update(@RequestBody ShipGroup shipGroup, RedirectAttributes rttr, HttpSession session) {

		if (authCheck(shipGroup, session) == 0) {

			shipgroupMapper.update(shipGroup);
		} else {

			rttr.addFlashAttribute("msgType", "실패");
			rttr.addFlashAttribute("msg", "회원 관리 권한이 없습니다.");
		}
		return "redirect:/";
	}

	// 4. 회원 삭제
	@DeleteMapping("/groupdelete")
	public void delete(@RequestBody ShipGroup shipGroup, RedirectAttributes rttr, HttpSession session) {

		if (authCheck(shipGroup, session) == 0) {

			shipgroupMapper.delete(shipGroup);
		} else {

			rttr.addFlashAttribute("msgType", "실패");
			rttr.addFlashAttribute("msg", "회원 삭제 권한이 없습니다.");
		}
	}
}
