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

import com.battleship.common.utils.AutoGenerateStr;
import com.battleship.domain.Player;
import com.battleship.domain.Room;
import com.battleship.enums.PlayerStateEnum;
import com.battleship.enums.RoomStateEnum;
import com.battleship.service.HallService;
import com.battleship.service.RoomService;
import com.google.gson.Gson;

@Controller
public class RoomController extends BaseController {
	private static final Logger logger = LoggerFactory.getLogger(RoomController.class);

	private static final String BACK_HALL_PAGE = "hall/index_hall";
	private static final String INDEX_PAGE = "room/index_room";
	private static final String ADD_PAGE   = "room/add_room";
	
	@Autowired
	private RoomService service;
	
	@Autowired
	private HallService hallService;
	
	@RequestMapping(value = "/room.add", method = RequestMethod.GET)
	public String add(HttpServletRequest request, Model model) {
		return ADD_PAGE;
	}
	
	@RequestMapping(value = "/room.insert", method = RequestMethod.GET)
	public String insert(HttpServletRequest request, Model model) {
		Room room = service.getRoom(request);
		Room sessionRoom = getRoom(request);
		Player me = getPlayer(request);
		me.setState(PlayerStateEnum.NONE);
		if(sessionRoom == null){
			room.addPlayer(me);
			room.setRoomID("R-" + AutoGenerateStr.getRandomStr(null, 8));
			hallService.addRoom(room);
		} else {
			hallService.removePlayerFromRoomSearch(room, me);;
			request.setAttribute("room", null);
			setRoom(request, null);
			return BACK_HALL_PAGE;
		}
		room.setState(RoomStateEnum.WAIT);
		setRoom(request, room);
		request.setAttribute("room", room);
		request.setAttribute("me", me);
		return INDEX_PAGE;
	}
	
	@RequestMapping(value = "/room.exit", method = RequestMethod.GET)
	public String exit(HttpServletRequest request, Model model) {
		try{
			if(getPlayer(request) != null && getRoom(request) != null){
				logger.info("player : {} exit room : {} ", getPlayer(request).getAccount(), getRoom(request).getRoomID());
				Room room = hallService.getRoomByRoomID(getRoom(request).getRoomID());
				hallService.removePlayerFromRoom(room, getPlayer(request));
				// player close browser.
				if("false".equalsIgnoreCase(request.getParameter("isExit"))){
//					hallService.removePlayer(getPlayer(request));
//					request.getSession().invalidate();
				}
				request.setAttribute("room", null);
				setRoom(request, null);
			}
		} catch(Exception e){
			logger.info("Error :  {} ", e.toString());
		}
		return BACK_HALL_PAGE;
	}
	
	@RequestMapping(value = "/room.in", method = RequestMethod.GET)
	public String in(HttpServletRequest request, Model model) {
		Room room = hallService.getRoomByRoomID(request.getParameter("roomID"));
		Player me = getPlayer(request);
		me.setState(PlayerStateEnum.NONE);
		if(hallService.addPlayerInRoom(room, me)){
			room.setState(RoomStateEnum.FULL);
			request.setAttribute("room", room);
			request.setAttribute("me", me);
			setRoom(request, room);
			return INDEX_PAGE;
		}
		return BACK_HALL_PAGE;
	}

	private Gson gson = new Gson();
	
	@RequestMapping(value = "/room.info.update", method = RequestMethod.GET)
	public String updateInfo(HttpServletRequest request,
			HttpServletResponse response, Model model) throws IOException {
		String roomID = request.getParameter("roomID");
		Room room = hallService.getRoomByRoomID(roomID);
		room = service.updateRoomInfo(request, room, getPlayer(request));
		// logger.info("room.info.update {} , {} ", getPlayer(request).getAccount(), gson.toJson(room));
		response.setContentType("json");
		response.setHeader("Cache-Control", "nocache");
		response.setCharacterEncoding("utf-8");
		response.getWriter().print(gson.toJson(room));
		response.getWriter().close();
		return null;
	}
	
	@RequestMapping(value = "/room.start", method = RequestMethod.GET)
	public String start(HttpServletRequest request,
			HttpServletResponse response, Model model) throws IOException {
		service.startGame(hallService.getRoomByRoomID(getRoom(request).getRoomID()));
		response.setContentType("json");
		response.setHeader("Cache-Control", "nocache");
		response.setCharacterEncoding("utf-8");
		response.getWriter().print("");
		response.getWriter().close();
		return null;
	}
	
	@RequestMapping(value = "/room.to.start", method = RequestMethod.GET)
	public String toStart(HttpServletRequest request,
			HttpServletResponse response, Model model) throws IOException {
		Integer toStartPass = Integer.valueOf(request.getParameter("toStartPass"));
		service.toStartGame(hallService.getRoomByRoomID(getRoom(request).getRoomID()), toStartPass);
		logger.info("room.to.start {} ", toStartPass);
		response.setContentType("json");
		response.setHeader("Cache-Control", "nocache");
		response.setCharacterEncoding("utf-8");
		response.getWriter().print("");
		response.getWriter().close();
		return null;
	}
	
	@RequestMapping(value = "/room.stop", method = RequestMethod.GET)
	public String stop(HttpServletRequest request,
			HttpServletResponse response, Model model) throws IOException {
		service.stopGame(hallService.getRoomByRoomID(getRoom(request).getRoomID()));
		response.setContentType("json");
		response.setHeader("Cache-Control", "nocache");
		response.setCharacterEncoding("utf-8");
		response.getWriter().print("");
		response.getWriter().close();
		return null;
	}
	
	@RequestMapping(value = "/room.openFire", method = RequestMethod.GET)
	public String openFier(HttpServletRequest request,
			HttpServletResponse response, Model model) throws IOException {
		String openFireLocation = request.getParameter("openFireLocation");
		response.setContentType("json");
		response.setHeader("Cache-Control", "nocache");
		response.setCharacterEncoding("utf-8");
		response.getWriter().print(
				gson.toJson(
						service.tryHit(
								hallService.getRoomByRoomID(getRoom(request).getRoomID()), getPlayer(request), openFireLocation)));
		response.getWriter().close();
		return null;
	}
}
