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
    private int siNum; // 선박 번호
    private String siName; // 선박 이름
    private String siDoes; // 선박 설명
    private char siCert; // 인증 여부
    private String siCode; // 선박 코드
}
