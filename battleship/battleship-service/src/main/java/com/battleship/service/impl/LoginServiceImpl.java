package com.battleship.service.impl;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.battleship.common.utils.AutoGenerateStr;
import com.battleship.domain.Player;
import com.battleship.service.LoginService;

@Service("LoginService")
public class LoginServiceImpl implements LoginService {
	
	private static final Logger logger = LoggerFactory.getLogger(LoginServiceImpl.class);
	
	private static String ACCOUNT = "Guest-";

	// private Gson gson = new Gson();
	
	public synchronized Player getAccount(List<Player> players) {
		Boolean isNotNew = Boolean.FALSE;
		String tmpAccount = null;
		while(!isNotNew) {
			tmpAccount = generateAccount();
			Boolean isDiff = Boolean.TRUE;
			for(Player player : players) {
				if(tmpAccount.equals(player.getAccount())) {
					isDiff = Boolean.FALSE;
				}
			}
			if(isDiff) {
				isNotNew = Boolean.TRUE;
			}
		}
		return new Player(tmpAccount);
	}
	
	private String generateAccount(){
		return generateAccount(null);
	}
	
	private String generateAccount(String exclude){
		exclude=exclude==null?"":exclude;
		String tempAccount = AutoGenerateStr.getRandomStr(null, 6);
		logger.info("generate account and login by : {}{}", ACCOUNT , tempAccount);
		return ACCOUNT + tempAccount;
	}
	
	public static void main(String args[]){
		LoginServiceImpl ls = new LoginServiceImpl();
		int x = 0;
		while(x < 10){
			ls.generateAccount();
			++x;
		}
	}
}
