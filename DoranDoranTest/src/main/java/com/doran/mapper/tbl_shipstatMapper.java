package com.doran.mapper;

import org.apache.ibatis.annotations.Mapper;

import com.doran.entity.Waypoint;

@Mapper
public interface tbl_shipstatMapper {

	public Waypoint getShipStat(int siNum);

}
