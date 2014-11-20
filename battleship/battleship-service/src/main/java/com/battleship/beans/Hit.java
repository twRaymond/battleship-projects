package com.battleship.beans;

import java.io.Serializable;

public class Hit implements Serializable {

	private static final long serialVersionUID = -2813679791226505097L;
	
	private String shipID;
	private String location;
	private Boolean valid;
	
	public String getShipID() {
		return shipID;
	}
	public void setShipID(String shipID) {
		this.shipID = shipID;
	}
	public String getLocation() {
		return location;
	}
	public void setLocation(String location) {
		this.location = location;
	}
	public Boolean getValid() {
		return valid;
	}
	public void setValid(Boolean valid) {
		this.valid = valid;
	}
}
