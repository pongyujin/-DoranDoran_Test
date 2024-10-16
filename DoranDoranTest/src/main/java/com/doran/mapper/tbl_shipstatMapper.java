package com.doran.mapper;

import org.apache.ibatis.annotations.Mapper;

import com.doran.entity.tbl_waypoint;

@Mapper
public interface tbl_shipstatMapper {

	public tbl_waypoint getShipStat(int siNum);

}
