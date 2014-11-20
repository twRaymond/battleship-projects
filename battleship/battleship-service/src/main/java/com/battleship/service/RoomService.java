package com.battleship.service;

import javax.servlet.http.HttpServletRequest;

import com.battleship.beans.Hit;
import com.battleship.domain.Player;
import com.battleship.domain.Room;


public interface RoomService {

	public Room getRoom(HttpServletRequest request);

	public void startGame(Room room);
	
	public void stopGame(Room room);
	
	public Room updateRoomInfo(HttpServletRequest request, Room room, Player player);

	public Hit tryHit(Room room, Player player, String location);

	public void toStartGame(Room room, Integer pass);

}
