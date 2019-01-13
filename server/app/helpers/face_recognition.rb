require 'net/http'
require 'json'

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
  return personIds.key(JSON.parse(response.body)[0]['candidates'][0]['personId'])
end
  
end
