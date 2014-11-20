package com.battleship.service;

import java.util.List;

import com.battleship.domain.Player;

public interface LoginService {
	public Player getAccount(List<Player> players);
}
