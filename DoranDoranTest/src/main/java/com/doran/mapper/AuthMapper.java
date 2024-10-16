package com.doran.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.doran.entity.tbl_group;
import com.doran.entity.tbl_ship;

@Mapper
public interface AuthMapper {

	// 1. 그룹 멤버 리스트 전체 불러오기
	public List<tbl_group> groupList(String siCode);
	// 2. 그룹 초대
	public void invite(tbl_group tbl_group);
	// 3. 권한 수정
	public void update(tbl_group tbl_group);
	// 4. 선박 등록자 확인
	public tbl_ship topAuth(tbl_ship tbl_ship);
	// 5. 회원 삭제
	public void delete(tbl_group tbl_group);
	
}
