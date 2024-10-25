package com.doran.controller;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.web.client.RestTemplate;

@Controller
public class GoogleLoginController {

    @Value("${GOOGLE_CLIENT_ID}")
    private String googleClientId;

    @Value("${GOOGLE_CLIENT_SECRET}")
    private String googleClientSecret;

    @Value("${GOOGLE_REDIRECT_URI}")
    private String googleRedirectUri;

    @GetMapping("/main2/google-callback")
    public String googleCallback(@RequestParam("code") String code, RedirectAttributes rttr, HttpSession session) {
        String googleTokenUrl = "https://oauth2.googleapis.com/token";

        System.out.println(googleClientId);
        // 토큰을 얻기 위한 요청 파라미터 구성
        Map<String, String> params = new HashMap<>();
        params.put("grant_type", "authorization_code");
        params.put("client_id", googleClientId);
        params.put("client_secret", googleClientSecret);
        params.put("redirect_uri", googleRedirectUri);
        params.put("code", code);

        // RestTemplate로 POST 요청하여 access_token 획득
        RestTemplate restTemplate = new RestTemplate();
        ResponseEntity<String> response = restTemplate.postForEntity(googleTokenUrl, params, String.class);

        // 응답에서 access_token 파싱
        String accessToken = parseAccessToken(response.getBody());

        // access_token을 이용해 구글 사용자 정보 가져오기
        String userInfoUrl = "https://www.googleapis.com/oauth2/v2/userinfo";
        HttpHeaders headers = new HttpHeaders();
        headers.add("Authorization", "Bearer " + accessToken);
        HttpEntity<String> entity = new HttpEntity<>(headers);
        ResponseEntity<String> userInfoResponse = restTemplate.exchange(userInfoUrl, HttpMethod.GET, entity, String.class);

        // 사용자 정보 처리
        String userInfo = userInfoResponse.getBody();
        System.out.println(userInfo);

        // 사용자 정보를 세션에 저장하거나 처리
        session.setAttribute("user", userInfo);

        // 로그인 성공 메시지 설정
        rttr.addFlashAttribute("msgType", "로그인 성공");
        rttr.addFlashAttribute("msg", "구글 로그인 성공!");

        return "redirect:/main";
    }

    // access_token 파싱 메서드 (필요에 따라 정의)
    private String parseAccessToken(String body) {
        // JSON 파싱 등의 방법으로 access_token을 추출
        return "access_token"; // 실제 파싱 로직으로 대체해야 함
    }
}
