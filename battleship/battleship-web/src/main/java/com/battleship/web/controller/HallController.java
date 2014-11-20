package com.battleship.web.controller;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.battleship.service.HallService;

@Controller
public class HallController {
	private static final Logger logger = LoggerFactory.getLogger(HallController.class);
	
	private static final String INDEX_PAGE = "hall/index_hall";
	
	@Autowired
	private HallService service;
	
	@RequestMapping(value = "/hall.index", method = RequestMethod.GET)
	public String doInit(HttpServletRequest request, Model model) {
		String ipAddress = request.getHeader("X-FORWARDED-FOR");
		if (ipAddress == null) {
			ipAddress = request.getRemoteAddr();
		}
		logger.info("ipAddress : {}", ipAddress);
		model.addAttribute("ipAddress", ipAddress);
		return INDEX_PAGE;
	}

	@RequestMapping(value = "/hall.playersHtml", method = RequestMethod.GET)
	public String updatePlayers(HttpServletRequest request,
			HttpServletResponse response, Model model) throws IOException {
		// logger.info("start hall.players");
    	response.setContentType("text/html;charset=UTF-8");   
		response.setHeader("Cache-Control", "nocache");
		response.setCharacterEncoding("utf-8");
		response.getWriter().print(service.getAllPlayerHTML());
		response.getWriter().close();
		return null;
	}

	@RequestMapping(value = "/hall.roomHtml", method = RequestMethod.GET)
	public String updateRoomJson(HttpServletRequest request,
			HttpServletResponse response, Model model) throws IOException {
		// logger.info("start hall.room");
    	response.setContentType("text/html;charset=UTF-8");   
		response.setHeader("Cache-Control", "nocache");
		response.setCharacterEncoding("utf-8");
		response.getWriter().print(service.getAllRoomHTML());
		response.getWriter().close();
		return null;
	}
}
