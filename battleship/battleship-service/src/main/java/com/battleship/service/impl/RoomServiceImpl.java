package com.battleship.service.impl;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Service;

import com.battleship.beans.Hit;
import com.battleship.domain.Player;
import com.battleship.domain.PlayerMap;
import com.battleship.domain.Room;
import com.battleship.enums.PlayerStateEnum;
import com.battleship.enums.RoomStateEnum;
import com.battleship.service.RoomService;

@Service("RoomService")
public class RoomServiceImpl implements RoomService {

	public static String ROOM_NAME = "roomName";
	public static String ROOM_SEC = "boutSec";
	
	public Room getRoom(HttpServletRequest request) {
		Room room = new Room();
		room.setRoomName(request.getParameter(ROOM_NAME));
		room.setBoutSec(Integer.valueOf(request.getParameter(ROOM_SEC)));
		return room;
	}

	public Room updateRoomInfo(HttpServletRequest request, Room room, Player me) {
		String myState = request.getParameter("myState");
		String myMap = request.getParameter("myMap");
		Boolean isMaster = getMaster(room.getPlayers(), me);
		RoomStateEnum roomState = RoomStateEnum.valueOf(request.getParameter("state"));
		if(room != null){
			// When click start and count backwards
			if(isMaster && RoomStateEnum.READY.equals(roomState) && room.getGoStart() == 0){
				room.setState(RoomStateEnum.PLAY);
			} else if(RoomStateEnum.END.equals(roomState)){
				if(room.getPlayers().size() == 2){
					room.setState(RoomStateEnum.FULL);
				} else {
					room.setState(RoomStateEnum.WAIT);
				}
			}
			for(Player p: room.getPlayers()){
				if(p.equals(me)){
					p.setState(PlayerStateEnum.valueOf(myState));
					if(RoomStateEnum.READY.equals(roomState)){
						PlayerMap playMap = new PlayerMap();
						playMap.setConfiguration(myMap);
						p.setMap(playMap);
					}
					if(RoomStateEnum.PLAY.equals(roomState)){
						p.getMap().changeFlag();
					}
				}
				if(RoomStateEnum.PLAY.equals(roomState) && p.getMap().getHp() == 0){
					room.setState(RoomStateEnum.END);
					room.setControlAuth(0);
				}
			}
			if(RoomStateEnum.PLAY.equals(roomState) && room.getPlayers().size() == 1){
				room.setState(RoomStateEnum.END);
				room.setControlAuth(0);
			}
		}
		return room;
	}

	public void startGame(Room room) {
		room.setState(RoomStateEnum.READY);
	}

	public void stopGame(Room room) {
		if(room.getPlayers().size() == 2){
			room.setState(RoomStateEnum.FULL);
		} else {
			room.setState(RoomStateEnum.WAIT);
		}
	}
	
	private Boolean getMaster(List<Player> players, Player me){
		int index = 0;
		for(Player p: players){
			if(p.equals(me)){
				return index==0;
			}
			index++;
		}
		return Boolean.FALSE;
	}

	public Hit tryHit(Room room, Player me, String location) {
		Hit hit = new Hit();
		if(room != null){
			for(Player p: room.getPlayers()){
				if(!p.equals(me)){
					room.changeControlAuth();
					hit = p.getMap().tryHit(location);
					p.getMap().hasHit();
				}
			}
		}
		return hit;
	}

	public void toStartGame(Room room, Integer pass) {
		room.setGoStart(pass);
	}	
}
