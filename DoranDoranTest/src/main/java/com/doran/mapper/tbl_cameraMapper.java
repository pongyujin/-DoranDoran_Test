package com.doran.mapper;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface tbl_cameraMapper {

	void cameraInsert(String obsName, String obsImg);

	
}
