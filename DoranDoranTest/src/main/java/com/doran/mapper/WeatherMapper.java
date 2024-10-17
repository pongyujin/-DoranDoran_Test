package com.doran.mapper;

import org.apache.ibatis.annotations.Mapper;

import com.doran.entity.Weather;

@Mapper
public interface WeatherMapper {

	public void insertWeather(Weather weather);

}
