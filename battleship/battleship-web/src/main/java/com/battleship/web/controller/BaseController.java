package com.battleship.web.controller;

import javax.servlet.http.HttpServletRequest;

import com.battleship.domain.Player;
import com.battleship.domain.Room;

public class BaseController {
	
	public Player getPlayer(HttpServletRequest request){
		return (Player)request.getSession().getAttribute("user_" + request.getSession().getId());
	}
	
	public void setPlayer(HttpServletRequest request, Player player){
		request.getSession().setAttribute("user_" + request.getSession().getId(), player);
	}
	
	public void setRoom(HttpServletRequest request, Room room){
		request.getSession().setAttribute("room_" + request.getSession().getId(), room);
	}

	public Room getRoom(HttpServletRequest request){
		return (Room)request.getSession().getAttribute("room_" + request.getSession().getId());
	}
}
