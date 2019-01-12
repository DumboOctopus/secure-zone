package org.secure_zone.client;


import org.bytedeco.javacpp.opencv_core.IplImage;
import org.bytedeco.javacv.*;

import static org.bytedeco.javacpp.opencv_imgcodecs.*;
import java.io.File;

import javax.imageio.ImageIO;



public class camera_parser implements Runnable{
	CanvasFrame canvas;
	FrameGrabber grabber;
	static boolean interrupted = false;
	static String fileName;
	
	public camera_parser() {
		canvas = new CanvasFrame("Camera");
		grabber = new OpenCVFrameGrabber(0);
		canvas.setDefaultCloseOperation(javax.swing.JFrame.EXIT_ON_CLOSE);
	}

	public void stop() {
		try {
			grabber.release();
			canvas.dispose();
		}
		catch(Exception e) {}
	}
	
	public void run() {

		OpenCVFrameConverter.ToIplImage converter = new OpenCVFrameConverter.ToIplImage();
		IplImage img;
		try {
			grabber.start();
			while (true) {
				try {
				if(interrupted){
					break;
				}

				saveImage();

				Thread.sleep(10000);
				}
				catch(Exception e) {
				}
			}
			grabber.release();
			canvas.dispose();
		} catch (Exception e) {
			e.printStackTrace();
		}
		
	}

	public void saveImage(){
		try {
			Frame frame = grabber.grab();
			OpenCVFrameConverter.ToIplImage converter = new OpenCVFrameConverter.ToIplImage();

			IplImage img = converter.convert(frame);
			File tempFile = File.createTempFile("secure_zone-client-photos-", ".png");

			cvSaveImage(tempFile.getAbsolutePath(), img);	
			System.out.println(tempFile.getAbsolutePath());
			// send to Neil
			
			
			tempFile.deleteOnExit();
			try{
				Thread.sleep(1000);
			}
			catch(Exception e){}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public static void main(String [] file) {
		
		interrupted = false;
		camera_parser gs = new camera_parser();
		fileName = "hi.png";
		gs.run();
	}

}
