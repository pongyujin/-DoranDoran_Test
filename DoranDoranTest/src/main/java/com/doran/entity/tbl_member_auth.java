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
public class tbl_member_auth {
    private int userAuthNum; // 사용자 권한 번호
    private int memId; // 회원 아이디
    private int authNum; // 권한 번호
    private String createdAt; // 등록 날짜
}
