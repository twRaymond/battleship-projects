package com.battleship.domain;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

public class Hall implements Serializable {
	
	private static final long serialVersionUID = -1816567063414840080L;
	
	private List<Room> rooms;
	private List<Player> players;

	public Hall(){
		rooms = new ArrayList<Room>();
		players = new ArrayList<Player>();
	}
	
	public List<Room> getRooms() {
		return rooms;
	}
	public Room getRoom(Room room) {
		for(Room r: rooms){
			if(r.equals(room)) return r;
		}
		return null;
	}
	public void setRooms(List<Room> rooms) {
		this.rooms = rooms;
	}
	public List<Player> getPlayers() {
		return players;
	}
	public void setPlayers(List<Player> players) {
		this.players = players;
	}
}
