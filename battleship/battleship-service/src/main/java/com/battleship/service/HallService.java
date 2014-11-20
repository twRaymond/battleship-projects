package com.battleship.service;

import java.util.List;

import com.battleship.domain.Player;
import com.battleship.domain.Room;

public interface HallService {
	public void addPlayer(Player player);
	public Boolean addPlayerInRoom(Room room, Player player);
	public void removePlayer(Player player);
	public void addRoom(Room room);
	public void removeRoom(Room room);
	public void removePlayerFromRoom(Room room, Player player);
	public void removePlayerFromRoomSearch(Room room, Player player);
	public Room getRoomByRoomID(String roomID);
	
	public List<Player> getAllPlayer();
	public List<Room> getAllRoom();
	public List<Player> getPlayerByRoom(Room room);
	public String getAllPlayerHTML();
	public String getAllRoomHTML();
}
