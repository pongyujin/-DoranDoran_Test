package com.doran.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.doran.entity.Ship;

@Mapper
public interface ShipMapper {

	// 1. 로그인 아이디로 전체 선박 리스트 조회
	public List<Ship> shipList(String memId);
	// 2. 선박 등록 신청
	public int application(Ship ship);
	// 3. 선박 등록 신청 승인
	public int approveShip(Ship ship);
	// 4. 선박 운항 상태 변경
	public int sailStatus(Ship ship);
	
	// 정유진이 만듬 
	public Ship findShipBySiCode(String siCode);

}
