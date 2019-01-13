package org.secure_zone.client;

public class client_master {
	
	static camera_parser cp;
	
	public static void main(String [] args) {
		UserInfo.main(null);
		
	//	SafeWord.main(null);
		
		ScanArea.main(null);
		
		cp = new camera_parser();
		
	}
}
