package com.doran.controller;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.doran.entity.Camera;
import com.doran.entity.Gps;
import com.doran.entity.Weather;
import com.doran.mapper.CameraMapper;
import com.doran.mapper.GpsMapper;
import com.doran.mapper.WeatherMapper;

@RequestMapping("/statistics")
@RestController
public class ShipStatRestController {

	@Autowired
	private GpsMapper gpsmapper;

	@Autowired
	private WeatherMapper weathermapper;

	@Autowired
    private CameraMapper cameraMapper;
	
	@GetMapping("/{siCode}/{sailNum}")
	public Map<String, Object> getShipStat(@PathVariable("siCode") String siCode,
			@PathVariable("sailNum") int sailNum) {
		System.out.println(siCode);
		System.out.println(sailNum);

		// GPS 데이터 조회
		List<Gps> gpsList = gpsmapper.getGps(sailNum);
		System.out.println("gpsList : " + gpsList);

		// 날씨+배터리 정보 조회
		List<Weather> weatherList = weathermapper.weatherList(new Weather(siCode, sailNum));
		System.out.println("weatherList : " + weatherList);

		// 결과를 Map으로 반환
		Map<String, Object> response = new HashMap<>();
		response.put("gpsList", gpsList);
		response.put("weatherList", weatherList);

		return response;
	}

	@PostMapping("/upload/image")
	public ResponseEntity<String> uploadImage(@RequestParam("formData") MultipartFile imageFile) {
	    if (!imageFile.isEmpty()) {
	        try {
	            // 파일 저장 디렉토리 설정
	            String uploadDir = new File("uploads").getAbsolutePath();
	            String fileName = UUID.randomUUID() + "_" + imageFile.getOriginalFilename();
	            Path uploadPath = Paths.get(uploadDir + "/" + fileName);

	            // 파일 저장
	            Files.copy(imageFile.getInputStream(), uploadPath, StandardCopyOption.REPLACE_EXISTING);

	            // Camera 객체 생성 및 데이터 설정
	            Camera camera = new Camera();
	            camera.setSiCode("oliviaship01");
	            camera.setObsName("장애물 이름");
	            camera.setObsImg(uploadPath.toString());  // 이미지 경로 설정
	            camera.setSailNum(1);

	            // CameraMapper를 통해 데이터베이스에 삽입
	            cameraMapper.cameraInsert(camera);

	            return ResponseEntity.ok("파일 업로드 성공");
	        } catch (IOException e) {
	            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("파일 업로드 실패: " + e.getMessage());
	        }
	    } else {
	        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("업로드된 파일이 없습니다.");
	    }
	}



}
