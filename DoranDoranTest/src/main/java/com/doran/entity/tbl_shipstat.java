package com.doran.entity;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@ToString
public class tbl_shipstat {

	private int statNum; // 상태 번호
	private int siNum; // 선박 번호
	private String statDest; // 목적지 명
	private double statLat; // 목적지 위도
	private double statLng; // 목적지 경도
	private String statRoute; // 이동 경로
	private String statStatus; // 운항 상태
	private String statBattery;// 배터리 상태
	private String createdAt; // 등록 시간
}
