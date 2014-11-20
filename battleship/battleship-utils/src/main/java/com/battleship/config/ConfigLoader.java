package com.battleship.config;

import java.io.InputStream;
import java.util.Properties;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


public class ConfigLoader {
	private static final Logger logger = LoggerFactory.getLogger(ConfigLoader.class);
	
	private static Properties prop = null;
	private static String defaultName = "/initContext.properties";
	
	public void load(){
		load("");
	}

	public void load(String configName){
		prop = new Properties();
		try {
			String tmpFileName = "".equalsIgnoreCase(configName)?defaultName:configName;
			logger.info("load file ... > {}", tmpFileName);
			InputStream resourcePath = getClass().getResourceAsStream(tmpFileName);
			prop.load(resourcePath);
		} catch(Exception e){
			logger.error(e.toString());
		}
	}
	
	public static Properties getProp() {
		return prop;
	}

	public static void setProp(Properties prop) {
		ConfigLoader.prop = prop;
	}
	
	public String getKey(String key){
		return prop.getProperty(key);
	}

	public static String getKey(Properties resource, String key){
		return resource.getProperty(key);
	}
}
