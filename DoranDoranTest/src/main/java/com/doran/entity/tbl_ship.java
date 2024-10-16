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
public class tbl_ship {
	
    private String siCode; // 선박 코드
    private String memId; // 회원 아이디
    private String siName; // 선박 이름
    private String siDocs; // 선박 증빙서류
    private char siCert; // 인증 여부
    private char sailStatus; // 운항 상태
}
