package com.personal.spring;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.context.annotation.EnableAspectJAutoProxy;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@EnableAspectJAutoProxy
@Controller
public class HomeController {
	private static final Logger LOGGER = LogManager.getLogger(HomeController.class);
	// 클라이언트가 요청한 서비스 주소와 메소드를 연결
	// http://localhost:8091
	// http://loclhost:8091/
	@RequestMapping(value= {"","/"}, method=RequestMethod.GET)
	public String home() {
		// /WEB-INF/views/home.jsp
		LOGGER.info("게시판 프로그램 시작");
		return "home";
	}
}
