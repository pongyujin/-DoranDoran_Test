//package com.doran.controller;
//
//import org.springframework.stereotype.Controller;
//import org.springframework.web.bind.annotation.*;
//
//import java.util.Map;
//
//@Controller
//public class HwGpsController {
//
//    @RequestMapping(value = "/gps-data", method = RequestMethod.POST)
//    @ResponseBody
//    public String receiveGpsData(@RequestBody Map<String, Object> data) {
//        // 개별 값 출력
//        double latitude = (double) data.get("latitude"); // 위도
//        double longitude = (double) data.get("longitude"); // 경도
//        double speed = (double) data.get("speed"); // 속도
//        double heading = (double) data.get("heading"); // 북쪽기준 방위각 0~360
//        String time = (String) data.get("time"); // 시간
//
//        System.out.println("위도 : " + latitude);  
//        System.out.println("경도 : " + longitude); 
//        System.out.println("속도 : " + speed + " m/s"); 
//        System.out.println("방위각 : " + heading + " 도"); 
//        System.out.println("시간 : " + time); 
//
//        return "Data received successfully";
//    }
//}
//
//
