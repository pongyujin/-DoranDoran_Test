package com.doran.mapper;

import org.apache.ibatis.annotations.Mapper;

import com.doran.entity.Member;

@Mapper
public interface MemberMapper {

	// 1. 회원가입
	public int memberJoin(Member member);
	// 2. 로그인
	public Member memberLogin(Member member);
	// 3. 아이디 중복 체크
	public Member registerCheck(String memID);
	
}
