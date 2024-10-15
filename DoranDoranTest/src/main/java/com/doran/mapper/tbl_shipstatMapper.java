package com.doran.mapper;

import org.apache.ibatis.annotations.Mapper;

import com.doran.entity.tbl_shipstat;

@Mapper
public interface tbl_shipstatMapper {

	public tbl_shipstat getShipStat(int siNum);

}
