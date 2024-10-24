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

	// 0. 로그인한 사용자의 그룹 내 권한 확인
	@PostMapping("/authCheck")
	public @ResponseBody int authCheck(@RequestBody ShipGroup shipGroup, HttpSession session) {
	    Member login = (Member) session.getAttribute("user");

	    if (login == null) {
	        System.out.println("authCheck - 로그인되지 않은 사용자입니다.");
	        return -1; // 로그인되지 않은 상태
	    }

	    // 로그인한 사용자의 그룹 내 권한 확인
	    ShipGroup check = shipgroupMapper.authCheck(shipGroup);

	    if (check == null) {
	        System.out.println("authCheck - 그룹에 속하지 않은 사용자입니다.");
	        return -2; // 그룹에 없는 경우
	    }

	    System.out.println("authCheck - 로그인한 사용자의 권한 번호: " + check.getAuthNum());
	    return check.getAuthNum(); // 로그인한 사용자의 권한 반환
	}
	// 1. 선박번호로 그룹 멤버 리스트 가져오기
	@RequestMapping("/grouplist")
	public @ResponseBody List<ShipGroup> groupList(String siCode) {
		List<ShipGroup> groupList = shipgroupMapper.groupList(siCode);
		System.out.println("ShipGroupController : " + groupList);
		return groupList;
	}

	// 소유자 확인 후 초대할 사람은 선택된 권한, 로그인한 사용자는 소유자일 경우 권한을 0으로 설정
	@PostMapping("/groupinvite")
	public ResponseEntity<String> invite(@RequestBody ShipGroup shipGroup, HttpSession session) {
	    // 로그인된 사용자 정보 확인
	    Member login = (Member) session.getAttribute("user");

	    if (login == null) {
	        System.out.println("로그인된 사용자가 없습니다.");
	        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("로그인이 필요합니다.");
	    }

	    // 선박의 소유자 확인
	    Ship ownerShip = shipMapper.findShipBySiCode(shipGroup.getSiCode());
	    System.out.println("groupinvite : "+ ownerShip );

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

	    // 로그인한 사용자가 선박 소유자인지 확인하여 권한 0으로 설정
	    if (ownerShip.getMemId().equals(login.getMemId())) {
	        System.out.println("현재 로그인한 사용자는 소유자입니다. 관리자 권한으로 설정.");
	        // 소유자인 현재 로그인한 사용자의 권한을 0으로 설정해야 함
	        ShipGroup ownerGroup = new ShipGroup();
	        ownerGroup.setMemId(login.getMemId());
	        ownerGroup.setSiCode(shipGroup.getSiCode());
	        ownerGroup.setAuthNum(0); // 소유자는 관리자로 설정
	        shipgroupMapper.invite(ownerGroup); // 소유자를 그룹에 추가
	    }

	    // 초대된 사용자는 선택된 권한으로 설정
	    System.out.println("초대된 사용자의 권한은: " + shipGroup.getAuthNum());
	    int cnt = shipgroupMapper.invite(shipGroup); // shipGroup에는 이미 authNum(선택된 권한)이 포함됨

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
	public ResponseEntity<String> update(@RequestBody ShipGroup shipGroup, HttpSession session) {
	    Member login = (Member) session.getAttribute("user");

	    if (login == null) {
	        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("로그인이 필요합니다.");
	    }

	    System.out.println("권한 수정할 대상 사용자: " + shipGroup.getMemId());
	    System.out.println("권한 수정할 대상 선박: " + shipGroup.getSiCode());
	    System.out.println("로그인한 사용자 ID: " + login.getMemId());

	    // 로그인된 사용자의 권한 확인 (관리자인지 체크)
	    ShipGroup adminCheckGroup = new ShipGroup();
	    adminCheckGroup.setSiCode(shipGroup.getSiCode());
	    adminCheckGroup.setMemId(login.getMemId()); // 로그인한 사용자의 memId를 사용
	    
	    int authNum = authCheck(adminCheckGroup, session); // 관리자 여부 확인
	    System.out.println();
	    if (authNum == 0) { // 로그인된 사용자가 관리자인 경우
	        System.out.println("로그인한 사용자는 관리자입니다.");
	        shipgroupMapper.update(shipGroup); // 권한 수정
	        return ResponseEntity.ok("권한 수정 성공");
	    } else {
	        return ResponseEntity.status(HttpStatus.FORBIDDEN).body("권한이 없습니다.");
	    }
	}


	// 4. 회원 삭제
	@DeleteMapping("/groupdelete")
	public ResponseEntity<String> delete(@RequestBody ShipGroup shipGroup, HttpSession session) {
	    Member login = (Member) session.getAttribute("user");

	    if (login == null) {
	        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("로그인이 필요합니다.");
	    }

	    if (authCheck(shipGroup, session) == 0) { // 로그인된 사용자가 관리자인지 확인
	        shipgroupMapper.delete(shipGroup); // 사용자 삭제
	        return ResponseEntity.ok("삭제 성공");
	    } else {
	        return ResponseEntity.status(HttpStatus.FORBIDDEN).body("삭제 권한이 없습니다.");
	    }
	}

}
