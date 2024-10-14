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
public class tbl_lidar {
	private int lidNum; // 라이다 번호
	private int siNum; // 선박 번호
	private String obsName; // 장애물 이름
	private int obsDist; // 장애물과의 거리
	private String createdAt; // 등록 시간
}
