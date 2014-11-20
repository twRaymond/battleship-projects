package com.battleship.init;

import java.util.Properties;

import com.battleship.config.ConfigLoader;


public class InitContext {
	private static InitContext me;
	private static Properties prop = null;
	
//	private static String webRoot;
//	private static String webRootTmp;
//	private static String webRootTmpCaptcha;
	
	@SuppressWarnings("static-access")
	public void init(){
		ConfigLoader configloader = new ConfigLoader();
		configloader.load();
		prop = configloader.getProp();
	}
	
	public static InitContext getInstance(){
		if(me == null){
			me = new InitContext();
			me.init();
		}
		return me;
	}
	public static String getWebRoot() {
		return prop.getProperty("web.root");
	}
	public static String getWebRootTmp() {
		return prop.getProperty("web.root.tmp");
	}
	public static String getWebRootTmp_() {
		return getWebRoot().concat(prop.getProperty("web.root.tmp"));
	}
	public static String getWebRootTmpCaptcha() {
		return prop.getProperty("web.root.tmp.captcha");
	}
	public static String getWebRootTmpCaptcha_() {
		return getWebRoot().concat(getWebRootTmp()).concat(prop.getProperty("web.root.tmp.captcha"));
	}
}
