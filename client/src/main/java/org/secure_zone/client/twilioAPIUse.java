package org.secure_zone.client;

import com.twilio.Twilio;
import com.twilio.rest.api.v2010.account.Message;
import com.twilio.type.PhoneNumber;


public class twilioAPIUse {

	public static final String phoneNumber = "+12138631028";
    public static final String ACCOUNT_SID =
            "AC6e42e7c33e5d686e45890bbaad42fe72";
    public static final String AUTH_TOKEN =
    		"f3d27eecfa8dff0eba760f28b7ff65cc";

    public static void sendText(String[] args) {
        Twilio.init(ACCOUNT_SID, AUTH_TOKEN);

        Message message = Message
                .creator(new PhoneNumber("+19095695446"), // to
                        new PhoneNumber(phoneNumber), // from
                        "Where's Wallace?")
                .create();

        System.out.println(message.getSid());
    }
    
    public static void main(String [] args) {
    	
    }
}

