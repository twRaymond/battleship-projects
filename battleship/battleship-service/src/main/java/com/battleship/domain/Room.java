package com.battleship.domain;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import com.battleship.enums.RoomStateEnum;

public class Room implements Serializable {
	
	private static final long serialVersionUID = -2026142471302031018L;
	
	private String roomID;
	private String roomName;
	private List<Player> players = new ArrayList<Player>();
	private Integer boutSec;
	private RoomStateEnum state;
	private Integer goStart = 5;
	private Integer controlAuth = 0; // 0 : master , 1: customer
	
	public String getRoomID() {
		return roomID;
	}
	public void setRoomID(String roomID) {
		this.roomID = roomID;
	}
	public String getRoomName() {
		return roomName;
	}
	public void setRoomName(String roomName) {
		this.roomName = roomName;
	}
	/**
	 * A room can have two player.
	 * @return
	 */
	public void addPlayer(Player player){
		if(players.size() < 2){
			players.add(player);
		}
	}
	public void exitPlayer(Player player){
		players.remove(player);
	}	
	public Integer getBoutSec() {
		return boutSec;
	}
	public void setBoutSec(Integer boutSec) {
		this.boutSec = boutSec;
	}
	/**
	 * The room state {Wait , Ready , Start}
	 * @return
	 */
	public RoomStateEnum getState() {
		return state;
	}
	public void setState(RoomStateEnum state) {
		this.state = state;
	}
	public Integer getGoStart() {
		return goStart;
	}
	public void setGoStart(Integer goStart) {
		this.goStart = goStart;
	}
	public List<Player> getPlayers() {
		return players;
	}
	public void setPlayers(List<Player> players) {
		this.players = players;
	}
	public Integer getControlAuth() {
		return controlAuth;
	}
	public void setControlAuth(Integer controlAuth) {
		this.controlAuth = controlAuth;
	}
	public void resetRoom() {
		controlAuth = 0;
		state = RoomStateEnum.FULL;
	}
	public void changeControlAuth(){
		if(controlAuth == 0){
			controlAuth = 1;
		} else {
			controlAuth = 0;
		}
	}
}
