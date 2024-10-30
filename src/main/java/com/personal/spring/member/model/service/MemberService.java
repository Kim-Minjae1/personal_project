package com.personal.spring.member.model.service;


import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import com.personal.spring.member.model.dao.MemberDao;
import com.personal.spring.member.model.vo.Member;


@Service
public class MemberService {
	
	@Autowired
	MemberDao memberDao;
	
	@Autowired
	BCryptPasswordEncoder bcryptPasswordEncoder;
	
	
	
	public int createMember(Member vo) {
		System.out.println("Received Member object in service: " + vo);
		int result = 0;
		try {
			vo.setUser_pw(bcryptPasswordEncoder.encode(vo.getUser_pw()));
			
//			String ori_pw = vo.getUser_pw();
//			String encode_pw = bcryptPasswordEncoder.encode(ori_pw);
//			vo.setUser_pw(encode_pw);
			
			result = memberDao.createMember(vo);
		}catch(Exception e){
			e.printStackTrace();
		}
		return result;
	}
	public Member getMemberByCity(String userId) {
        return memberDao.selectMemberByCity(userId);
    }
	
}
