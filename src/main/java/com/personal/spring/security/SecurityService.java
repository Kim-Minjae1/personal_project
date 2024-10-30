package com.personal.spring.security;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Component;

import com.personal.spring.member.model.dao.MemberDao;
import com.personal.spring.member.model.vo.Member;

@Component("loginService")
public class SecurityService implements UserDetailsService {
	
	@Autowired
	MemberDao memberDao;
	
	@Override
	public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
		// 실제 데이터베이스에서 회원 정보를 조회
		// 조회한 회원 정보를 User 형태로 변환해서 제공
		Member member = memberDao.selectMemberById(username);
		if(member != null) {
			return new SecurityUser(member);
		}
		return null;
	}

}
