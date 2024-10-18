package com.doran.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.doran.entity.ShipGroup;
import com.doran.entity.Ship;

@Mapper
public interface AuthMapper {

	// 1. 그룹 멤버 리스트 전체 불러오기
	public List<ShipGroup> groupList(String siCode);
	// 2. 그룹 초대
	public void invite(ShipGroup shipGroup);
	// 3. 권한 수정
	public void update(ShipGroup shipGroup);
	// 4. 권한 확인
	public Ship authCheck(Ship ship);
	// 5. 회원 삭제
	public void delete(ShipGroup shipGroup);
	
}
