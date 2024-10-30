package com.personal.spring.member.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.personal.spring.member.model.service.MemberService;
import com.personal.spring.member.model.vo.Member;
import org.springframework.web.client.RestTemplate;

import java.security.Principal;

@Controller
public class MemberViewController {

    @Autowired
    private MemberService memberService;

    @GetMapping("/loginPage")
    public String loginPage() {
        return "member/login"; // 로그인 페이지
    }

    @GetMapping("/join")
    public String joinPage() {
        return "member/join"; // 회원가입 페이지
    }

    @GetMapping("/home")
    public String home(Model model, Principal principal) {
        if (principal == null) {
            System.out.println("Principal is null");  // 디버깅 메시지
            return "redirect:/loginPage";  // 로그인 페이지로 리다이렉트
        }

        String userId = principal.getName();
        System.out.println("User ID: " + userId);  

        Member member = memberService.getMemberByCity(userId);

        if (member == null) {
            System.out.println("Member is null");  
            return "home";
        }

        String userAddress = member.getUser_address();
        System.out.println("User Address: " + userAddress); 

        String weatherInfo = getWeatherInfo(userAddress);
        System.out.println("Weather Info: " + weatherInfo);  

        model.addAttribute("userAddress", userAddress);
        model.addAttribute("weather", weatherInfo);

        return "home";  
    }

    private String getWeatherInfo(String address) {
        // OpenWeatherMap API를 이용하여 날씨 정보를 가져오는 로직
        String apiKey = "YOUR_API_KEY";  // 자신의 API 키를 입력
        String apiUrl = "http://api.openweathermap.org/data/2.5/weather?q=" + address + "&appid=" + apiKey;

        RestTemplate restTemplate = new RestTemplate();
        String response = restTemplate.getForObject(apiUrl, String.class);

       
        return response;  
    }
}
