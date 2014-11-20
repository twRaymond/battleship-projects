package com.battleship.domain;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.battleship.beans.Hit;

public class PlayerMap implements Serializable {
	
	private static final Logger logger = LoggerFactory.getLogger(PlayerMap.class);

	private static final long serialVersionUID = -3803385330503042902L;

	public String configuration;
	
	public Integer updateFlag; // 0 : none , 1 : has hit, 2 : need update , 3 : update success
	public Integer hp = 0;
	
	public List<Hit> hits;
	
	public PlayerMap(){
		hits = new ArrayList<Hit>();
		updateFlag = 0;
		hp = 17;
	}
	
	public static String[][] defaultMap = new String [][] {
			{"","A","B","C","D","E","F","G","H","I","L"},
			{"0","A_0","B_0","C_0","D_0","E_0","F_0","G_0","H_0","I_0","L_0"},
			{"1","A_1","B_1","C_1","D_1","E_1","F_1","G_1","H_1","I_1","L_1"},
			{"2","A_2","B_2","C_2","D_2","E_2","F_2","G_2","H_2","I_2","L_2"},
			{"3","A_3","B_3","C_3","D_3","E_3","F_3","G_3","H_3","I_3","L_3"},
			{"4","A_4","B_4","C_4","D_4","E_4","F_4","G_4","H_4","I_4","L_4"},
			{"5","A_5","B_5","C_5","D_5","E_5","F_5","G_5","H_5","I_5","L_5"},
			{"6","A_6","B_6","C_6","D_6","E_6","F_6","G_6","H_6","I_6","L_6"},
			{"7","A_7","B_7","C_7","D_7","E_7","F_7","G_7","H_7","I_7","L_7"},
			{"8","A_8","B_8","C_8","D_8","E_8","F_8","G_8","H_8","I_8","L_8"},
			{"9","A_9","B_9","C_9","D_9","E_9","F_9","G_9","H_9","I_9","L_9"},
		};

	public void setConfiguration(String configuration) {
		this.configuration = configuration;
	}

	public Hit tryHit(String location){
		Hit hit = new Hit();
		String[] ships = configuration.split("#");
		Boolean valid = Boolean.FALSE;
		hit.setShipID("");
		for(String ship: ships){
			String shipID = ship.split("%")[0];
			logger.info(" ship name {} location : ", shipID);
			for(String l: ship.split("%")[1].split("@")){
				if(l.equals(location)) {
					hit.setShipID(shipID);
					valid = Boolean.TRUE;
					--hp;
				}	
			}
		}
		hit.setLocation(location);
		hit.setValid(valid);
		getHits().add(hit);
		return hit;
	}
	
	public Integer getHp() {
		return hp;
	}

	public void setHp(Integer hp) {
		this.hp = hp;
	}

	public synchronized void changeFlag(){
		if(updateFlag == 1){
			updateFlag = 2;
		} else if(updateFlag == 2) {
			updateFlag = 3;
		}
	} 
	
	public void hasHit(){
		updateFlag = 1;
	}
	
	public List<Hit> getHits() {
		return hits;
	}

	public void setHits(List<Hit> hits) {
		this.hits = hits;
	}
	
	public static String testFormat = "shipAC%A_0@A_1@A_2@A_3@A_4#shipB%A_5@B_5@C_5@D_5#shipS%C_8@D_8@E_8#shipD%H_0@H_1@H_2#shipPB%I_0@I_1";
	public static String testFormatFormHTML = "shipAC%A_0@A_1@A_2@A_3@A_4#shipB%D_0@D_1@D_2@D_3#shipS%G_1@G_2@G_3#shipD%D_5@D_6@D_7#shipPB%H_5@H_6";
	public static void main(String args[]){
		String[] ships = testFormatFormHTML.split("#");
		for(String ship: ships){
			logger.info(" ship name {} location : ", ship.split("%")[0]);
			for(String location: ship.split("%")[1].split("@")){
				logger.info(" {} ,  ", location);
			}
		}
	}
}
