require 'net/http'
require 'json'
require 'twilio-ruby'



module FaceRecognition
  def check_face (input_url)
  file = File.read('../../../../secrets.json') #file in secure-zone
  data_hash = JSON.parse(file)
  file  = File.read('../../../../personIds.json') #file in secure-zone
  personIds = JSON.parse(file)
  
  uri = URI('https://westcentralus.api.cognitive.microsoft.com/face/v1.0/detect')
  uri.query = URI.encode_www_form({
    # Request parameters
    'returnFaceId' => 'true',
    'returnFaceLandmarks' => 'false'
  })
  request = Net::HTTP::Post.new(uri.request_uri)
  # Request headers
  request['Content-Type'] = 'application/json'
  # Request headers
  request['Ocp-Apim-Subscription-Key'] = data_hash['secret_key']
  # Request body
  request.body = "{'url': '" + input_url + "'}"
  response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
      http.request(request)
  end
  id = (JSON.parse(response.body)[0]['faceId'])
  
uri = URI('https://westcentralus.api.cognitive.microsoft.com/face/v1.0/identify')
uri.query = URI.encode_www_form({
})

request = Net::HTTP::Post.new(uri.request_uri)
# Request headers
request['Content-Type'] = 'application/json'
# Request headers
request['Ocp-Apim-Subscription-Key'] = data_hash['secret_key']
# Request body
request.body = "{'personGroupId': 'names', 'faceIds': ['" + id + "'], 'maxNumOfCandidatesReturned': 1, 'confidenceThreshold': 0.5}"

response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
    http.request(request)
end
  json = JSON.parse(response.body)[0]['candidates']
if json.length != 0
person = personIds.key(json[0]['faceId'])
account_sid = data_hash['account_sid'] # Your Account SID from www.twilio.com/console
auth_token = data_hash['auth_token']   # Your Auth Token from www.twilio.com/console

@client = Twilio::REST::Client.new account_sid, auth_token
message = @client.messages.create(
    body: "Warning, " + person + " nearby",
    to: "+19095695446",    # Replace with your phone number
    from: "+12138631028")  # Replace with your Twilio number

puts message.sid
end
end
end
