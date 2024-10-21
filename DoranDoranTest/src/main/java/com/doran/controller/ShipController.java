package com.doran.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.doran.entity.Member;
import com.doran.entity.Sail;
import com.doran.entity.Ship;
import com.doran.mapper.ShipMapper;

// 선박 정보 등록 및 선박 정보 반환
@RequestMapping("/ship")
@RestController
public class ShipController {

	@Autowired
	private ShipMapper shipMapper;

	// 1. 선박 전체 리스트 불러오기
	@RequestMapping("/all")
	public List<Ship> shipList(HttpSession session) {

		Member login = (Member) session.getAttribute("user");

		List<Ship> shipList = shipMapper.shipList(login.getMemId());
		return shipList;
	}

	// 2. 선박 등록 신청
	@PostMapping("/application")
	public void application(Ship ship, RedirectAttributes rttr) {

		ship.setSiCert('0'); // 미승인
		ship.setSailStatus('0'); // 운항 x
		int cnt = shipMapper.application(ship);

		if (cnt > 0) {

			rttr.addFlashAttribute("msgType", "성공");
			rttr.addFlashAttribute("msg", "선박 등록을 신청했습니다. 관리자 승인을 기다려주세요");
		} else {

			rttr.addFlashAttribute("msgType", "실패");
			rttr.addFlashAttribute("msg", "선박 등록을 실패했습니다. 다시 시도해주세요");
		}
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
		System.out.println(ship);
		int cnt = shipMapper.sailStatus(ship);
	}
}
