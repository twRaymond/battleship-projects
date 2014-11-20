package com.battleship.web.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.battleship.domain.Player;
import com.battleship.service.HallService;
import com.battleship.service.LoginService;

@Controller
public class LoginController extends BaseController {
	private final static Logger logger = LoggerFactory.getLogger(LoginController.class);

	public final static String INDEX_HALL_PAGE = "hall/index_hall";
	public final static String INDEX_PAGE = "index";

	@Autowired
	private LoginService service;
	@Autowired
	private HallService hallService;
	
	@RequestMapping(value = "/index.doInit", method = RequestMethod.GET)
	public String index(HttpServletRequest request, Model model) {
		return INDEX_PAGE;
	}
	
	@RequestMapping(value = "/login.on", method = RequestMethod.GET)
	public String on(HttpServletRequest request, Model model) {
		Player player = (Player)request.getSession().getAttribute("user_" + request.getSession().getId());
		if(player == null){
			player = service.getAccount(hallService.getAllPlayer());
			hallService.addPlayer(player);
		} else {
			logger.info("Connect Account is {}" , player.getAccount());
		}
		request.setAttribute("user_info", player);
		request.getSession().setAttribute("user_" + request.getSession().getId(), player);
		return INDEX_HALL_PAGE;
	}
	
	@RequestMapping(value = "/login.off", method = RequestMethod.GET)
	public String off(HttpServletRequest request, Model model) {
		HttpSession session = request.getSession();
		Player player = getPlayer(request);
		if(player != null){
			hallService.removePlayer(player);
			session.invalidate();
		}
		return INDEX_PAGE;
	}
}
