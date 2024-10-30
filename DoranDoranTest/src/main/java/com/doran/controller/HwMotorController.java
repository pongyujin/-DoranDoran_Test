package com.doran.controller;

import org.springframework.web.bind.annotation.*;
import org.json.JSONObject;

@RestController
@RequestMapping("/receive_voltage")
public class HwMotorController {

    @PostMapping
    public String receiveVoltage(@RequestBody String jsonData) {
        try {
            JSONObject json = new JSONObject(jsonData);
            double voltage = json.getDouble("voltage");

            // 받은 전압 데이터 출력
            System.out.println("Received voltage: " + voltage + " V");
            return "Voltage received successfully";

        } catch (Exception e) {
            e.printStackTrace();
            return "Error processing voltage data";
        }
    }
}
