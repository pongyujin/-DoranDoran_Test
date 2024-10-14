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
public class tbl_group {
    private int grpNum; // 그룹 번호
    private String grpName; // 그룹 이름
    private int memId; // 회원 아이디
    private String createdAt; // 등록 날짜
}
