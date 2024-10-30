package com.doran.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.tomcat.util.codec.binary.Base64;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.doran.entity.Camera;
import com.doran.mapper.CameraMapper;
import com.fasterxml.jackson.databind.ObjectMapper;

@RestController
@RequestMapping("/receive-data")
public class HwCameraController {
	// 일단 DB저장 안하고있음
	// 여기서 매퍼 가져와야할듯

	@Autowired
	private CameraMapper cameraMapper;

	@Autowired
	private AlertController alertController;

	// 멀티파트 데이터를 수신하여 처리

	@PostMapping(consumes = "multipart/form-data")
<<<<<<< HEAD
	public ResponseEntity<Map<String, String>> receiveData(@RequestParam("json") String jsonData,
	        @RequestParam("image") MultipartFile imageFile) {
	    Map<String, String> response = new HashMap<>();
	    try {
	        // Parse the JSON data (for verification)
	        ObjectMapper objectMapper = new ObjectMapper();
	        List<Map<String, Object>> detections = objectMapper.readValue(jsonData, List.class);
	        System.out.println("HWCameraController detections : " + detections);
=======
	public ResponseEntity<String> receiveData(@RequestParam("json") String jsonData,
			@RequestParam("image") MultipartFile imageFile) {
		try {
			// JSON 데이터를 파싱하여 감지 객체 리스트로 변환
			ObjectMapper objectMapper = new ObjectMapper();
			List<Map<String, Object>> detections = objectMapper.readValue(jsonData, List.class);
			System.out.println("Received detections: " + detections);
>>>>>>> branch 'master' of https://github.com/pongyujin/DoranDoran_Test.git

	        // Check if the image file exists
	        if (imageFile != null && !imageFile.isEmpty()) {
	            byte[] imageBytes = imageFile.getBytes(); // Get the byte data of the image file

	            // Encode the image to a Base64 string
	            String base64Image = Base64.encodeBase64String(imageBytes);
	            response.put("status", "success");
	            response.put("image", "data:image/jpeg;base64," + base64Image); // Include the image data in the JSON response

<<<<<<< HEAD
	            // Optionally save the image and JSON data to the database
	            for (Map<String, Object> detection : detections) {
	                String className = (String) detection.get("className");
	                if (className != null && !className.isEmpty()) {
	                    Camera camera = new Camera();
	                    camera.setSiCode("7");
	                    camera.setSailNum(1);
	                    camera.setObsName(className);
	                    camera.setObsImg(imageBytes); // Save image bytes as BLOB
	                    cameraMapper.cameraInsert(camera); // Save to the database
	                }
	            }

	        } else {
	            response.put("status", "error");
	            response.put("message", "No image file provided.");
	        }

	        // If processing was successful, send an alert to the client
	        if (response.get("status").equals("success")) {
	            alertController.sendAlert(response);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	        response.put("status", "error");
	        response.put("message", "Failed to process the request");
	    }
	    return ResponseEntity.ok(response);
=======
						// 현재 날짜를 설정 (createdAt은 NOW()로 자동 설정됨)
						cameraMapper.cameraInsert(camera); // DB에 저장
						System.out.println("Image data saved in database for class: " + className);
					}
				}
			}
			return ResponseEntity.ok("Data and image saved successfully in the database");
		} catch (Exception e) {
			e.printStackTrace();
			return ResponseEntity.status(500).body("Failed to process the request");
		}
>>>>>>> branch 'master' of https://github.com/pongyujin/DoranDoran_Test.git
	}


	// 이미지 파일을 DB에서 불러와 반환하는 엔드포인트 추가
	@GetMapping("/image/{imgNum}")
	public ResponseEntity<byte[]> getImage(@PathVariable int imgNum) {
		try {
			// imgNum에 해당하는 Camera 객체를 DB에서 조회
			Camera camera = cameraMapper.selectCameraByImgNum(imgNum);

			if (camera != null && camera.getObsImg() != null) {
				// 이미지 데이터를 byte 배열로 가져오기
				byte[] imageBytes = camera.getObsImg();

				// Http 헤더 설정 (이미지 형식 지정)
				HttpHeaders headers = new HttpHeaders();
				headers.setContentType(MediaType.IMAGE_JPEG);

				// ResponseEntity를 통해 이미지 데이터를 반환
				return new ResponseEntity<>(imageBytes, headers, HttpStatus.OK);
			} else {
				return ResponseEntity.status(HttpStatus.NOT_FOUND).body(null);
			}
		} catch (Exception e) {
			e.printStackTrace();
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
		}
	}

}
