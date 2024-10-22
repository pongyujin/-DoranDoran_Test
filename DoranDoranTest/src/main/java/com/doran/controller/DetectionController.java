package com.doran.controller;

import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.http.ResponseEntity;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@RestController
@RequestMapping("/receive-data")
public class DetectionController {

	// 멀티파트 데이터를 수신
	@PostMapping(consumes = "multipart/form-data")
	public ResponseEntity<String> receiveData(@RequestParam("json") String jsonData, // 요청에서 "json" 필드로 전달된 데이터를 받음
			@RequestParam("image") MultipartFile imageFile // 요청에서 "image" 필드로 전달된 이미지 파일을 받음
	) {
		try {
			// JSON 문자열을 파싱하여 Java의 List<Map> 객체로 변환
			ObjectMapper objectMapper = new ObjectMapper();
			List<Map<String, Object>> detections = objectMapper.readValue(jsonData, List.class);
			System.out.println("Received detections: " + detections);

			// 이미지 파일이 null이 아니고 비어있지 않은지 확인합니다.
			if (imageFile != null && !imageFile.isEmpty()) {
				// 이미지 파일의 바이트 데이터를 가져옵니다.
				byte[] imageBytes = imageFile.getBytes();
				
				// 현재 날짜와 시간을 가져와 형식 지정
                String timestamp = new SimpleDateFormat("yyyyMMdd_HHmmss").format(new Date());
				
				// 각 감지된 객체에 대해 처리합니다.
				for (Map<String, Object> detection : detections) {
					// 감지된 객체의 클래스 이름을 가져옵니다.
					String className = (String) detection.get("className");
					// 클래스 이름이 null이 아니고 비어있지 않은 경우에만 저장을 진행합니다.
					if (className != null && !className.isEmpty()) {
						// 파일 이름에 클래스 이름과 시간 스탬프를 추가
                        String fileName = className + "_" + timestamp + ".jpg";
						// 이미지 파일을 저장할 경로를 설정합니다.
						Path path = Paths.get("src/main/resources/images/" + fileName);

						// 저장할 폴더가 없으면 생성
						Files.createDirectories(path.getParent());

						// 이미지 저장
						Files.write(path, imageBytes);
						// 이미지 저장 절대경로 확인
						System.out.println("Saved image as: " + path.toAbsolutePath());
					}
				}
			}

			return ResponseEntity.ok("Data and image received and saved successfully");
		} catch (Exception e) {
			e.printStackTrace();
			return ResponseEntity.status(500).body("Failed to process the request");
		}
	}
}
