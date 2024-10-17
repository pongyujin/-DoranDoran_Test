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
public class Weather {
	
    private int wNum; // 기상 번호
    private String wDate; // 기상일
    private String wTime; // 기상 시간
    private double wTemp; // 온도
    private double wWindSpeed; // 풍속
    private double wWaveHeight; // 파고
    private double wSeaTemp; // 해수 온도
    private String wRegion; // 기상 지역
    private int sailNum;
    private String siCode;
}
