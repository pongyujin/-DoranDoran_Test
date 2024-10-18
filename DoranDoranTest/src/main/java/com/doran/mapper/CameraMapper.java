package com.doran.mapper;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface CameraMapper {

	void cameraInsert(String obsName, String obsImg);

	
}
