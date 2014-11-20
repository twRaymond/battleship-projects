package com.battleship.domain;

import java.io.Serializable;

import com.battleship.enums.PlayerStateEnum;

public class Player implements Serializable {
	
	private static final long serialVersionUID = -477218395341628948L;
	
	private String account;
	private PlayerStateEnum state;
	private PlayerMap map;
	
	public String getAccount() {
		return account;
	}
	public void setAccount(String account) {
		this.account = account;
	}
	public Player(String account) {
		super();
		this.account = account;
	}
	public PlayerStateEnum getState() {
		return state;
	}
	public void setState(PlayerStateEnum state) {
		this.state = state;
	}
	public PlayerMap getMap() {
		return map;
	}
	public void setMap(PlayerMap map) {
		this.map = map;
	}
	
}
