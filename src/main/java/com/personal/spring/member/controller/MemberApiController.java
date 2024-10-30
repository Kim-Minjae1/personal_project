package com.personal.spring.member.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;

import com.personal.spring.member.model.service.MemberService;
import com.personal.spring.member.model.vo.Member;


@Controller
public class MemberApiController {
	
	@Autowired
	MemberService memberService;
	
	@ResponseBody
	@PostMapping("/join")
	public Map<String,String> createMember(@RequestBody Member vo){		
		
		Map<String, String> resultMap = new HashMap<String,String>();
		resultMap.put("res_code", "404");
		resultMap.put("res_msg", "회원가입중 오류가 발생했습니다.");
		System.out.println("Received Member object in Controller: " + vo);
		if(memberService.createMember(vo) > 0) {
			resultMap.put("res_code","200");
			resultMap.put("res_msg", "회원가입이 성공적으로 완료되었습니다.");
		}
		
		return resultMap;
	}
}
