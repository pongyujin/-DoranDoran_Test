package com.doran.mapper;

import org.apache.ibatis.annotations.Mapper;

import com.doran.entity.Camera;

@Mapper
public interface CameraMapper {

	void cameraInsert(Camera camera);


	
}
