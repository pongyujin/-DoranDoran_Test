package com.doran.controller;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.doran.entity.Member;
import com.doran.mapper.MemberMapper;

@Controller
public class MemberController {

	@Autowired
	private MemberMapper memberMapper;

	// 1. 회원가입
	@PostMapping("/memberJoin")
	public String memberJoin(Member member, RedirectAttributes rttr, HttpSession session) {
		
		System.out.println(member);

		if (member.getMemId() == null || member.getMemId().equals("") 
				|| member.getMemPw() == null || member.getMemPw().equals("") 
				|| member.getMemNick() == null || member.getMemNick().equals("")
				|| member.getMemEmail() == null || member.getMemEmail().equals("") 
				|| member.getMemPhone() == null || member.getMemPhone().equals("")) {

			// 회원가입 실패
			rttr.addFlashAttribute("msgType", "실패");
			rttr.addFlashAttribute("msg", "모든 항목을 기입해주세요");

		} else {

			int cnt = memberMapper.memberJoin(member);

			if (cnt > 0) {
				
				rttr.addFlashAttribute("msgType", "성공");
				rttr.addFlashAttribute("msg", "회원가입에 성공했습니다");
				session.setAttribute("user", member);
			} else {
				
				rttr.addFlashAttribute("msgType", "실패");
				rttr.addFlashAttribute("msg", "회원가입에 실패했습니다");
			}
		}
		return "redirect:/main";
	}

	// 2. 로그인
	@PostMapping("/memberLogin")
	public String memberLogin(Member member, RedirectAttributes rttr, HttpSession session) {
	    Member mvo = memberMapper.memberLogin(member);

	    if (mvo == null) {
	        System.out.println("세션에 저장할 사용자 정보: " + mvo);  // mvo 객체의 전체 값 확인
	        rttr.addFlashAttribute("msgType", "실패");
	        rttr.addFlashAttribute("msg", "아이디와 비밀번호를 확인해주세요");
	        session.setAttribute("openLoginModal", true);
	        return "redirect:/main";
	    } else {
	        // 로그인 성공 시 세션에 Member 객체 저장
	        session.setAttribute("user", mvo);
	        rttr.addFlashAttribute("msgType", "성공");
	        rttr.addFlashAttribute("msg", "로그인에 성공했습니다");

	        // 세션에 저장된 Member 객체가 모든 값을 가지고 있는지 확인하는 로그 출력
	        System.out.println("세션에 저장된 사용자 정보: " + session.getAttribute("user"));
	        System.out.println("닉네임: " + mvo.getMemNick());
	        System.out.println("이메일: " + mvo.getMemEmail());
	        System.out.println("전화번호: " + mvo.getMemPhone());

	        return "redirect:/main";  // main으로 이동
	    }
	}

	// 3. 아이디 중복 확인
	@RequestMapping("/registerCheck")
	public int registerCheck(@RequestParam("memID") String memID) {

		Member member = memberMapper.registerCheck(memID);
		if (member != null || memID.equals("")) {
			return 0;
		} else {
			return 1;
		}
	}

	// 4. 로그아웃
	@RequestMapping("/logout")
	public String logout(HttpSession session) {

		session.invalidate();
		return "redirect:/main";
		
	}
}
