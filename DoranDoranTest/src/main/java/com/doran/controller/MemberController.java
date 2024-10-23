package com.doran.controller;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
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
			rttr.addFlashAttribute("msgType", "회원가입 실패");
			rttr.addFlashAttribute("msg", "모든 항목을 기입해주세요");
			session.setAttribute("openJoinModal", true);

		} else {

			int cnt = memberMapper.memberJoin(member);

			if (cnt > 0) {
				
				rttr.addFlashAttribute("msgType", "회원가입 성공");
				rttr.addFlashAttribute("msg", "회원가입에 성공했습니다");
				session.setAttribute("user", member);
			} else {
				
				rttr.addFlashAttribute("msgType", "회원가입 실패");
				rttr.addFlashAttribute("msg", "회원가입에 실패했습니다");
			}
		}
		return "redirect:/main";
	}

	// 2. 로그인
	@PostMapping("/memberLogin")
	public String memberLogin(Member member, RedirectAttributes rttr, HttpSession session) {
	    
		Member user = memberMapper.memberLogin(member);
		
		if (user == null) {
	        
			rttr.addFlashAttribute("msgType", "로그인 실패");
			rttr.addFlashAttribute("msg", "아이디와 비밀번호를 확인해주세요");
			session.setAttribute("openLoginModal", true);

	        return "redirect:/main";  // main으로 이동
	    

		} else {

			// 로그인 성공
			rttr.addFlashAttribute("msgType", "로그인 성공");
			rttr.addFlashAttribute("msg", user.getMemNick()+"님, 환영합니다!");
			// 로그인 정보 세션 저장
			session.setAttribute("user", user);

			return "redirect:/main";
		}
	}

	// 3. 아이디 중복 확인
	@RequestMapping("/registerCheck")
	public @ResponseBody int registerCheck(@RequestParam("memId") String memId) {

		Member member = memberMapper.registerCheck(memId);
		if (member != null || memId.equals("")) {
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
