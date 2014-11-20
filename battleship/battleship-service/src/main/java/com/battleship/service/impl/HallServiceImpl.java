package com.battleship.service.impl;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.battleship.config.ConfigLoader;
import com.battleship.domain.Hall;
import com.battleship.domain.Player;
import com.battleship.domain.Room;
import com.battleship.enums.RoomStateEnum;
import com.battleship.service.HallService;

@Service("HallService")
@SuppressWarnings("unused")
public class HallServiceImpl implements HallService {
	private static ConfigLoader config;
	private static Hall hall;
	private static StringBuffer ALL_PLAYERS_HTML;
	private static StringBuffer ALL_ROOM_HTML;
	private static final Logger logger = LoggerFactory.getLogger(HallServiceImpl.class);
	
	public HallServiceImpl(){
		hall = new Hall();
		config = new ConfigLoader();
		config.load();
		ALL_PLAYERS_HTML = new StringBuffer();
	}
	/**
	 * When player login.
	 */
	public void addPlayer(Player player) {
		hall.getPlayers().add(player);
	}
	/**
	 * When player logout
	 */
	public void removePlayer(Player player) {
		hall.getPlayers().remove(player);
		for(Room room: hall.getRooms()){
			room.getPlayers().remove(player);
		}
	}
	/**
	 * When player create room 
	 */
	public void addRoom(Room room) {
		hall.getRooms().add(room);
	}

	/**
	 * When all player exit room 
	 */
	public void removeRoom(Room room) {
		hall.getRooms().remove(room);
	}

	public List<Player> getAllPlayer() {
//		logger.info("online player list : ");
		List<Player> tmpPlayers = hall.getPlayers();
//		for(Player tmpPlayer : tmpPlayers){
//			logger.info(" player : {} ", tmpPlayer.getAccount());
//		}
		return tmpPlayers;
	}
	
	public List<Room> getAllRoom() {
//		for(Room room: hall.getRooms()){
//			for(Player tmpPlayer : room.getPlayers()){
//				logger.info(" player at room[{}] : {} ", room.getRoomName(), tmpPlayer.getAccount());
//			}
//		}
		return hall.getRooms();
	}

	public List<Player> getPlayerByRoom(Room room) {
		return hall.getRoom(room).getPlayers();
	}

	public String getAllPlayerHTML() {
		StringBuffer HTML = new StringBuffer("<table>");
		for(Player player : getAllPlayer()){
			HTML.append("<tr><td>").append(player.getAccount()).append("</td></tr>");
		}
		HTML.append("</table>");
		ALL_PLAYERS_HTML = HTML;
		return HTML.toString();
	}
	
	public String updateAllPlayerHTML() {
		StringBuffer HTML = new StringBuffer("<table>");
		for(Player player : getAllPlayer()){
			HTML.append("<tr><td>").append(player.getAccount()).append("</td></tr>");
		}
		HTML.append("</table>");
		ALL_PLAYERS_HTML = HTML;
		return HTML.toString();
	}
	
	public String getAllRoomHTML() {
		StringBuffer HTML = new StringBuffer("<table>");
		HTML.append("<tr><td class='td_room_name_title td_title'>Room Name</td><td class='td_room_state_title td_title'>State</td></tr>");
		if(hall.getRooms().size() > 0){
			for(Room room: hall.getRooms()){
				HTML.append("<tr>");
				HTML.append("<td><div class='div_room_name'>").append(room.getRoomName()).append("</div></td>");
				HTML.append("<td class=''>").append(getRoomButton(room)).append("<td>");
				HTML.append("</tr>");
			}
		} else {
			HTML.append("<tr><td>&nbsp;<td/><td>&nbsp;</td></tr>");
		}
		HTML.append("</table>");
		ALL_ROOM_HTML = HTML;
		return HTML.toString();
	}
	
	private String getRoomButton(Room room) {
		String aLink = "<a href=\"/" + config.getKey("web.contextPath") + "/room.in?roomID=" + room.getRoomID()
				     + "\" onclick=\"addRoom('"+ room.getRoomID() + "')\" >";
		String aLink_ = "</a>";
		switch(room.getState()){
			case WAIT:
				return aLink + "<div class='div_room_wait'>WAIT</div>"+ aLink_;
			case FULL:
			case READY:
			case END:
				return "<div class='div_room_full'>FULL</div>";
			case PLAY:
				return "<div class='div_room_paly'>PLAY</div>";
		}
		return null;
	}
	
	public Room getRoomByRoomID(String roomID) {
		for(Room room: hall.getRooms()){
			if(room.getRoomID().equals(roomID)){
				return room;
			}
		}
		return null;
	}
	
	public void removePlayerFromRoom(Room room, Player player) {
		Boolean isNoPlayer = Boolean.FALSE;
		for(Room r: hall.getRooms()){
			if(r.equals(room)){
				r.getPlayers().remove(player);
				logger.info(" player exit room[{}] : {} ", room.getRoomName(), player.getAccount());
				if(r.getPlayers().size() == 0){
					isNoPlayer = Boolean.TRUE;
				} else {
					r.setState(RoomStateEnum.WAIT);
				}
			}
		}
		if(isNoPlayer) {
			removeRoom(room);
		}
	}

	public void removePlayerFromRoomSearch(Room room, Player player) {
		Boolean isNoPlayer = Boolean.FALSE;
		Boolean isFind = Boolean.FALSE;
		for(Room r: hall.getRooms()){
			for(Player p: r.getPlayers()){
				if(p.equals(player)){
					isFind = Boolean.TRUE;
				}
			}
			if(isFind){
				logger.info(" player exit room[{}] : {} ", room.getRoomName(), player.getAccount());
				r.getPlayers().remove(player);
			}
			if(r.getPlayers().size() == 0){
				isNoPlayer = Boolean.TRUE;
			} else {
				r.setState(RoomStateEnum.WAIT);
			}
			room = r;
		}
		if(isNoPlayer) {
			removeRoom(room);
		}
	}
	
	public Boolean addPlayerInRoom(Room room, Player player) {
		Boolean inState = Boolean.FALSE;
		for(Room r: hall.getRooms()){
			if(r.equals(room) && r.getPlayers().size() < 2){
				r.addPlayer(player);
				logger.info(" player in room[{}] : {} ", room.getRoomName(), player.getAccount());
				inState = Boolean.TRUE;
			}
		}
		return inState;
	}
}