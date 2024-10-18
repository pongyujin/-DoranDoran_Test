package com.doran.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.doran.entity.Gps;

@Mapper
public interface GpsMapper {

	public List<Gps> getGps(int sailNum);


}
