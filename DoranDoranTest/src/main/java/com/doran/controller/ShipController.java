package com.doran.controller;

import java.io.File;
import java.io.IOException;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.doran.entity.Member;
import com.doran.entity.Sail;
import com.doran.entity.Ship;
import com.doran.mapper.ShipMapper;

// 선박 정보 등록 및 선박 정보 반환
@Controller
public class ShipController {

	@Autowired
	private ShipMapper shipMapper;

	// 1. 선박 전체 리스트 불러오기
	@RequestMapping("/shipList")
	public @ResponseBody List<Ship> shipList(HttpSession session) {

		Member login = (Member) session.getAttribute("user");

		List<Ship> shipList = shipMapper.shipList(login.getMemId());
		
		System.out.println("ShipController : " + shipList);
		
		return shipList;
	}

	// 2. 선박 등록 신청
	@PostMapping("/shipRegister")
	public String application(Ship ship, RedirectAttributes rttr, HttpSession session) throws IllegalStateException, IOException {

		Member user = (Member)session.getAttribute("user");
		
		ship.setMemId(user.getMemId()); // 로그인 사용자 아이디
		ship.setSiCert('0'); // 미승인
		ship.setSailStatus('0'); // 운항 x

		if (!ship.getSiDocsFile().isEmpty()) {
		    String fileName = ship.getSiDocsFile().getOriginalFilename();
		    // 파일을 서버에 저장하는 로직
		    File destinationFile = new File("src/main/resources/siDocsFile/" + fileName);
		    ship.getSiDocsFile().transferTo(destinationFile);
		    
		    // 파일 경로를 데이터베이스에 저장
		    ship.setSiDocs("src/main/resources/siDocsFile/" + fileName); // 경로를 setter로 설정
		}
		
		int cnt = shipMapper.application(ship);

		if (cnt > 0) {

			rttr.addFlashAttribute("msgType", "성공");
			rttr.addFlashAttribute("msg", "선박 등록을 신청했습니다. 관리자 승인을 기다려주세요");
		} else {

			rttr.addFlashAttribute("msgType", "실패");
			rttr.addFlashAttribute("msg", "선박 등록을 실패했습니다. 다시 시도해주세요");
			session.setAttribute("openShipRegisterModal", true);
		}
		return "redirect:/main";
	}

	// 3. 선박 등록 승인
	@PutMapping("/update")
	public void approveShip(@RequestBody Ship ship) {

		ship.setSiCert('1'); // 승인
		shipMapper.approveShip(ship);
	}
	
	// 4. 선박 운항 상태 변경
	@PutMapping("/sailStatus")
	public void sailStatus(Sail sail, HttpSession session) {
		
		Member user = (Member)session.getAttribute("user");
		Ship ship = new Ship();
		ship.setMemId(user.getMemId());
		ship.setSiCode(sail.getSiCode());
		
		ship.setSailStatus(ship.getSailStatus() == '0' ? '1' : '0');
		int cnt = shipMapper.sailStatus(ship);
		
		// session 저장
		ship = getShip(ship);
		session.setAttribute("nowShip", ship);
	}
	
	// 5. 선박 정보 불러오기
	public Ship getShip(Ship ship) {
		
		ship = shipMapper.getShip(ship);
		return ship;
	}
	
	// 6. 세션에서 운항상태 불러오기
	@GetMapping("/sailStatus")
    public ResponseEntity<Map<String, Object>> getSailStatus(HttpSession session) {
		
        Ship nowShip = (Ship) session.getAttribute("nowShip");
        if (nowShip != null) {
            Map<String, Object> response = new HashMap<>();
            response.put("sailStatus", nowShip.getSailStatus());
            return ResponseEntity.ok(response);
        }
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(Collections.singletonMap("error", "Ship not found"));
    }
}
