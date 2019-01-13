package org.secure_zone.client;

import java.util.ArrayList;
import java.util.List;

import org.apache.http.HttpEntity;
import org.apache.http.NameValuePair;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.util.EntityUtils;

public class SafeWord {

	static String server = "https://secure-zone-backend.appspot.com";
	static String user_id = "1";
	static String user_name;
	
	public static void main(String [] args) {
		ArrayList <String> words = new ArrayList<String>();
		ArrayList <String> degree = new ArrayList<String>(); // 1-10

		// PROCESSING
		
		for(int i = 0; i < words.size(); i++) {
			post("word/add",words.get(i), degree.get(i));
		}
	}
	public static void post(String pageid, String username, String phone) {
		try {
			CloseableHttpClient client = HttpClientBuilder.create().build();
			String url = server + "/" + pageid;
			HttpPost securedResource = new HttpPost(url);
			List<NameValuePair> params = new ArrayList<NameValuePair>(2);
			user_name = username;
			params.add(new BasicNameValuePair("phone", phone));

			
			securedResource.setEntity(new UrlEncodedFormEntity(params, "UTF-8"));

//			CloseableHttpClient client = HttpClientBuilder.create().build();
//			String url = server + "/" + pageid;
//			HttpPost securedResource = new HttpPost(url);
//			securedResource.setEntity(new StringEntity(data));
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
