require 'net/http'

#CREATE PERSONGROUP
uri = URI('https://westcentralus.api.cognitive.microsoft.com/face/v1.0/persongroups/criminals')
uri.query = URI.encode_www_form({
})

request = Net::HTTP::Put.new(uri.request_uri)
# Request headers
request['Content-Type'] = 'application/json'
# Request headers
request['Ocp-Apim-Subscription-Key'] = ''
# Request body
request.body = '{"name": "criminals"}'

response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
    http.request(request)
end

puts response.body



#CREATE DETECT
uri = URI('https://westcentralus.api.cognitive.microsoft.com/face/v1.0/detect')
uri.query = URI.encode_www_form({
    # Request parameters
    'returnFaceId' => 'true',
    'returnFaceLandmarks' => 'false',
    'returnFaceAttributes' => 'age,gender,headPose,smile,facialHair,glasses,' +
        'emotion,hair,makeup,occlusion,accessories,blur,exposure,noise'
})

request = Net::HTTP::Post.new(uri.request_uri)
# Request headers
request['Content-Type'] = 'application/json'
# Request headers
request['Ocp-Apim-Subscription-Key'] = ''
# Request body
request.body = "{'url': 'https://timedotcom.files.wordpress.com/2014/06/justin-bieber-racist.jpg'}"

response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
    http.request(request)
end

puts response.body




#CREATE PERSONGROUP PERSON
uri = URI('https://westcentralus.api.cognitive.microsoft.com/face/v1.0/persongroups/test/persons')
uri.query = URI.encode_www_form({
})

request = Net::HTTP::Post.new(uri.request_uri)
# Request headers
request['Content-Type'] = 'application/json'
# Request headers
request['Ocp-Apim-Subscription-Key'] = ''
# Request body
request.body = "{'name': 'Person1'}"

response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
    http.request(request)
end

puts response.body


#PERSONGROUP PERSON ADD FACE
uri = URI('https://westcentralus.api.cognitive.microsoft.com/face/v1.0/persongroups/test/persons/b88e3db9-cbfa-438c-b614-543caf65151a/persistedFaces')
uri.query = URI.encode_www_form({
})

request = Net::HTTP::Post.new(uri.request_uri)
# Request headers
request['Content-Type'] = 'application/json'
# Request headers
request['Ocp-Apim-Subscription-Key'] = ''
# Request body
request.body = "{'url': 'https://timedotcom.files.wordpress.com/2014/06/justin-bieber-racist.jpg'}"

response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
    http.request(request)
end

puts response.body


#TRAIN
uri = URI('https://westcentralus.api.cognitive.microsoft.com/face/v1.0/persongroups/test/train')
uri.query = URI.encode_www_form({
})

request = Net::HTTP::Post.new(uri.request_uri)
# Request headers
request['Ocp-Apim-Subscription-Key'] = ''
# Request body
request.body = "{}"

response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
    http.request(request)
end

puts response.body


#IDENTIFY
uri = URI('https://westcentralus.api.cognitive.microsoft.com/face/v1.0/identify')
uri.query = URI.encode_www_form({
})

request = Net::HTTP::Post.new(uri.request_uri)
# Request headers
request['Content-Type'] = 'application/json'
# Request headers
request['Ocp-Apim-Subscription-Key'] = ''
# Request body
request.body = "{'personGroupId': 'test', 'faceIds': ['42157615-c8a3-486c-a2e3-be0905db4b16'], 'maxNumOfCandidatesReturned': 1, 'confidenceThreshold': 0.5}"

response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
    http.request(request)
end

puts response.body
