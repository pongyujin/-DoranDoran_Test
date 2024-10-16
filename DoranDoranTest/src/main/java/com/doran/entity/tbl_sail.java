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
public class tbl_sail {
	
    private int sailNum; // 사용자 권한 번호
    private String siCode; // 회원 아이디
    private String createdAt; // 등록 날짜
    private double startLat;
    private double startLng;
    private double endLat;
    private double endLng;
    private String comment;
}
