package com.doran.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.doran.entity.Camera;

@Mapper
public interface CameraMapper {

	int cameraInsert(Camera camera);

	List<Camera> getImage(Camera camera);


	
}
