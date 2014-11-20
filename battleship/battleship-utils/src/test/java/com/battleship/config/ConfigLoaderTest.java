package com.battleship.config;



public class ConfigLoaderTest {
	
	public static void main(String args[]){
		ConfigLoader cl = new ConfigLoader();
		cl.load();
		System.out.println(cl.getKey("web.root"));
	}
}
