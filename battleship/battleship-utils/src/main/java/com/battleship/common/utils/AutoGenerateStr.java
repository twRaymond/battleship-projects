package com.battleship.common.utils;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class AutoGenerateStr {
	
	private static final Logger logger = LoggerFactory.getLogger(AutoGenerateStr.class);
	
	public static String getRandomStr(String exclude, Integer length){
		exclude=exclude==null?"":exclude;
		
		String str = "";
		boolean addChar = false;
		while(str.length() < length){
			addChar = false;
			
			int charInt = (int)(Math.random() * 93) + 30;
			if(exclude.indexOf((char)charInt) > -1){
				logger.info("Auto generate exclude char : length-{}  int-{}", str.length(), charInt);
			} else if(charInt >= 48 && charInt <= 57){
				addChar = true;
			} else if(charInt >= 65 && charInt <= 90) {
				addChar = true;
			} else if(charInt >= 97 && charInt <= 122){
				addChar = true;
			}
			logger.info("Auto generate char : length-{}  int-{}", str.length(), charInt);
			if(addChar){
				str += (char) charInt;
			}
		}
		logger.info("generate string by : {}", str);
		return str;
	}
}
