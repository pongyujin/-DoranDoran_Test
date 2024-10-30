package com.doran.controller;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;

@Controller
public class AlertController {

    @Autowired
    private SimpMessagingTemplate messagingTemplate;

    public void sendAlert(Map<String, String> data) {
        messagingTemplate.convertAndSend("/topic/alerts", data);
    }
}