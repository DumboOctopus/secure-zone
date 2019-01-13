package org.secure_zone.client;

import org.apache.commons.codec.binary.Base64;
import org.apache.commons.io.FileUtils;
import org.apache.http.HttpEntity;
import org.apache.http.NameValuePair;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.util.EntityUtils;
import org.bytedeco.javacpp.opencv_core.IplImage;
import org.bytedeco.javacv.*;

import static org.bytedeco.javacpp.opencv_imgcodecs.*;
import java.io.File;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;

import javax.imageio.ImageIO;

public class camera_parser implements Runnable {
	CanvasFrame canvas;
	FrameGrabber grabber;
	static boolean interrupted = false;
	static String fileName;
	static String server = "https://secure-zone-backend.appspot.com";
	static String user_id = "1";

	public camera_parser() {
		canvas = new CanvasFrame("Camera");
		grabber = new OpenCVFrameGrabber(0);
		canvas.setDefaultCloseOperation(javax.swing.JFrame.EXIT_ON_CLOSE);
	}

	public void stop() {
		try {
			grabber.release();
			canvas.dispose();
		} catch (Exception e) {
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
					for(int i = 0; i < 100; i++) {
						try {
							grabber.start();
							if(interrupted)
								break;

							Frame frame = grabber.grab();

							img = converter.convert(frame);

							canvas.showImage(converter.convert(img));

							Thread.sleep(100);


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

					byte[] encoded = Base64.encodeBase64(FileUtils.readFileToByteArray(tempFile));
					String base64 = new String(encoded, StandardCharsets.US_ASCII);
					post("upload_image", base64);

					tempFile.deleteOnExit();
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
