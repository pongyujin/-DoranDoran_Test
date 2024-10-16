package com.doran.mapper;

import org.apache.ibatis.annotations.Mapper;

import com.doran.entity.tbl_weather;

@Mapper
public interface WeatherMapper {

	public void insertWeather(tbl_weather weather);

}
