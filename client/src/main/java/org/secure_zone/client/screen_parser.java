package org.secure_zone.client;

import java.awt.Rectangle;
import java.awt.Robot;
import java.awt.Toolkit;
import java.awt.image.BufferedImage;
import java.io.File;

import javax.imageio.ImageIO;

public class screen_parser {

	public screen_parser() {
		
	}
	public static void main(String [] args) {
		while(true) {
		try {
			Rectangle screenRect = new Rectangle(Toolkit.getDefaultToolkit().getScreenSize());
			BufferedImage capture = new Robot().createScreenCapture(screenRect);
			
			File tempFile = File.createTempFile("secure_zone-client-", "");
			
			ImageIO.write(capture, "png", tempFile);
			System.out.println(tempFile.getAbsolutePath());
			//send to neil
			tempFile.deleteOnExit();

		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		 }
		}
	}
}
