package org.secure_zone.client;

import com.cloudinary.Cloudinary;

import org.apache.http.HttpEntity;
import org.apache.http.NameValuePair;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;

import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.util.EntityUtils;
import org.bytedeco.javacpp.opencv_core.IplImage;
import org.bytedeco.javacv.*;

import static org.bytedeco.javacpp.opencv_imgcodecs.*;
import java.io.File;
import java.io.IOException;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


public class camera_parser implements Runnable {
	CanvasFrame canvas;
	FrameGrabber grabber;
	static boolean interrupted = false;
	static String fileName;
	static String server = "https://secure-zone.herokuapp.com";
	static String user_id = "1";

	public camera_parser() {
		canvas = new CanvasFrame("Camera");
		grabber = new OpenCVFrameGrabber(0);
		canvas.setDefaultCloseOperation(javax.swing.JFrame.EXIT_ON_CLOSE);
		canvas.setCanvasSize(1200, 900);

		
	}

	public void stop() {
		try {
			grabber.release();
			canvas.dispose();
		} catch (Exception e) {
		}
	}
	
	public static void putOnline(File data) {
		Cloudinary cloudinary = new Cloudinary();
		try {
			HashMap<String,Object> hm = new HashMap <String, Object>();
			hm.put("api_key","462933916592457");
			hm.put("api_secret","vvCcIJBnpeUij6bLCVRBhLfSOuo");
			hm.put("cloud_name","dcnsvbx3y");

			
			Map uploadResult = cloudinary.uploader().upload(data, hm);
			
			String publicId = (String) uploadResult.get("public_id");

			String cloudinaryServer = "https://res.cloudinary.com/dcnsvbx3y/image/upload/";
			
			String link = cloudinaryServer + publicId;
			System.out.println(link);
			
			post("upload_image", link);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	public void run() {

		OpenCVFrameConverter.ToIplImage converter = new OpenCVFrameConverter.ToIplImage();
		IplImage img;
		try {
			grabber.start();
			while (true) {

				try {
					if (interrupted) {
						break;
					}

					saveImage();
					for(int i = 0; i < 200; i++) {
						try {
							grabber.start();
							if(interrupted)
								break;

							Frame frame = grabber.grab();

							img = converter.convert(frame);

							canvas.showImage(converter.convert(img));

							Thread.sleep(50);


						} catch (Exception e) {
						}
					}
				} catch (Exception e) {
					e.printStackTrace();
				}

			}
		} catch (Exception e) {
		}
		}

			public void saveImage() {
				try { 
					Frame frame = grabber.grab();
					OpenCVFrameConverter.ToIplImage converter = new OpenCVFrameConverter.ToIplImage();

					IplImage img = converter.convert(frame);
					File tempFile = File.createTempFile("secure_zone-client-photos-", ".png");

					cvSaveImage(tempFile.getAbsolutePath(), img);
					System.out.println(tempFile.getAbsolutePath());

			//		byte[] encoded = Base64.encodeBase64(FileUtils.readFileToByteArray(tempFile));
			//		String base64 = new String(encoded, StandardCharsets.US_ASCII);
				    
			//		System.out.println("\n"+base64+"\n");
			//		post("upload_image", base64);
					
					putOnline(tempFile);

				//	tempFile.deleteOnExit();
					try {
						Thread.sleep(1000);
					} catch (Exception e) {
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
			}

			public static void main(String[] file) {

				interrupted = false;
				camera_parser gs = new camera_parser();
				fileName = "hi.png";
				gs.run();
			}

			public static void get(String pageid, String acceptType) {
				CloseableHttpClient client = HttpClientBuilder.create().build();
				try {
					String url = server + "/" + pageid;
					HttpGet securedResource = new HttpGet(url);
					securedResource.addHeader("Accept", "application/json");

					CloseableHttpResponse httpResponse = client.execute(securedResource);
					HttpEntity responseEntity = httpResponse.getEntity();
					String strResponse = EntityUtils.toString(responseEntity);
					EntityUtils.consume(responseEntity);
					System.out.println("get/strResponse" + strResponse);
					client.close();
				} catch (Exception e) {
					e.printStackTrace();
				}
			}

			public static void post(String pageid, String data) {
				try {
					CloseableHttpClient client = HttpClientBuilder.create().build();
					String url = server + "/" + pageid;
					HttpPost securedResource = new HttpPost(url);
					List<NameValuePair> params = new ArrayList<NameValuePair>(2);

					params.add(new BasicNameValuePair("picture", data));
					params.add(new BasicNameValuePair("user_id", user_id));

					
					securedResource.setEntity(new UrlEncodedFormEntity(params, "UTF-8"));

//					CloseableHttpClient client = HttpClientBuilder.create().build();
//					String url = server + "/" + pageid;
//					HttpPost securedResource = new HttpPost(url);
//					securedResource.setEntity(new StringEntity(data));
					securedResource.setHeader("Content-type", "application/json");
					securedResource.setHeader("Accept", "application/json");
					System.out.println(securedResource.toString());


					CloseableHttpResponse httpResponse = client.execute(securedResource);
					HttpEntity responseEntity = httpResponse.getEntity();
					try {
						String strResponse = EntityUtils.toString(responseEntity);
						System.out.println(strResponse);
						EntityUtils.consume(responseEntity);
					} catch (Exception e) {
						System.out.println("null");
					}
					httpResponse.close();
				} catch (Exception e) {
					e.printStackTrace();
				}
			}

		}
