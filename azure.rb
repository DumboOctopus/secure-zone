require 'net/http'
require 'json'

dictionary = {'Angela'=>[], 'Neil'=>[], 'Nathan'=>[]}
personIds = {}

file = File.read('secrets.json')
data_hash = JSON.parse(file)

#CREATE PERSONGROUP
uri = URI('https://westcentralus.api.cognitive.microsoft.com/face/v1.0/persongroups/names')
uri.query = URI.encode_www_form({
})

request = Net::HTTP::Put.new(uri.request_uri)
# Request headers
request['Content-Type'] = 'application/json'
# Request headers
request['Ocp-Apim-Subscription-Key'] = data_hash['secret_key']
# Request body
request.body = '{"name": "names"}'

response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
    http.request(request)
end




#CREATE DETECT FOR ANGELA
uri = URI('https://westcentralus.api.cognitive.microsoft.com/face/v1.0/detect')
uri.query = URI.encode_www_form({
    # Request parameters
    'returnFaceId' => 'true',
    'returnFaceLandmarks' => 'false'
})
Dir.foreach('./angela_pics') do |item|
    next if item == '.' or item == '..'
    request = Net::HTTP::Post.new(uri.request_uri)
    # Request headers
    request['Content-Type'] = 'application/json'
    # Request headers
    request['Ocp-Apim-Subscription-Key'] = data_hash['secret_key']
    # Request body
    request.body = "{'url': 'https://github.com/DumboOctopus/secure-zone/blob/master/angela_pics/" + item.to_s + "?raw=true'}"
    response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
        http.request(request)
    end
    dictionary['Angela'].push(JSON.parse(response.body)[0]['faceId'])
end


sleep(60)
#CREATE DETECT FOR NEIL
uri = URI('https://westcentralus.api.cognitive.microsoft.com/face/v1.0/detect')
uri.query = URI.encode_www_form({
    # Request parameters
    'returnFaceId' => 'true',
    'returnFaceLandmarks' => 'false'
})
Dir.foreach('./neil_pics') do |item|
    next if item == '.' or item == '..'
    request = Net::HTTP::Post.new(uri.request_uri)
    # Request headers
    request['Content-Type'] = 'application/json'
    # Request headers
    request['Ocp-Apim-Subscription-Key'] = data_hash['secret_key']
    # Request body
    request.body = "{'url': 'https://github.com/DumboOctopus/secure-zone/blob/master/neil_pics/" + item.to_s + "?raw=true'}"
    response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
        http.request(request)
    end
    dictionary['Neil'].push(JSON.parse(response.body)[0]['faceId'])
end


sleep(60)
#CREATE DETECT FOR NATHAN
uri = URI('https://westcentralus.api.cognitive.microsoft.com/face/v1.0/detect')
uri.query = URI.encode_www_form({
    # Request parameters
    'returnFaceId' => 'true',
    'returnFaceLandmarks' => 'false'
})
Dir.foreach('./nathan_pics') do |item|
    next if item == '.' or item == '..'
    request = Net::HTTP::Post.new(uri.request_uri)
    # Request headers
    request['Content-Type'] = 'application/json'
    # Request headers
    request['Ocp-Apim-Subscription-Key'] = data_hash['secret_key']
    # Request body
    request.body = "{'url': 'https://github.com/DumboOctopus/secure-zone/blob/master/nathan_pics/" + item.to_s + "?raw=true'}"
    response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
        http.request(request)
    end
    dictionary['Nathan'].push(JSON.parse(response.body)[0]['faceId'])
end

puts dictionary



#CREATE PERSONGROUP PERSON
uri = URI('https://westcentralus.api.cognitive.microsoft.com/face/v1.0/persongroups/names/persons')
uri.query = URI.encode_www_form({
})

request = Net::HTTP::Post.new(uri.request_uri)
# Request headers
request['Content-Type'] = 'application/json'
# Request headers
request['Ocp-Apim-Subscription-Key'] = data_hash['secret_key']
# Request body
request.body = "{'name': 'Angela'}"

response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
    http.request(request)
end

personIds['Angela'] = JSON.parse(response.body)['personId']


#CREATE PERSONGROUP PERSON
uri = URI('https://westcentralus.api.cognitive.microsoft.com/face/v1.0/persongroups/names/persons')
uri.query = URI.encode_www_form({
})

request = Net::HTTP::Post.new(uri.request_uri)
# Request headers
request['Content-Type'] = 'application/json'
# Request headers
request['Ocp-Apim-Subscription-Key'] = data_hash['secret_key']
# Request body
request.body = "{'name': 'Neil'}"

response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
    http.request(request)
end

 personIds['Neil'] =  JSON.parse(response.body)['personId']



#CREATE PERSONGROUP PERSON
uri = URI('https://westcentralus.api.cognitive.microsoft.com/face/v1.0/persongroups/names/persons')
uri.query = URI.encode_www_form({
})

request = Net::HTTP::Post.new(uri.request_uri)
# Request headers
request['Content-Type'] = 'application/json'
# Request headers
request['Ocp-Apim-Subscription-Key'] = data_hash['secret_key']
# Request body
request.body = "{'name': 'Nathan'}"

response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
    http.request(request)
end

personIds['Nathan'] = JSON.parse(response.body)['personId']

puts personIds




#PERSONGROUP PERSON ADD FACE
uri = URI('https://westcentralus.api.cognitive.microsoft.com/face/v1.0/persongroups/names/persons/' + personIds['Angela'] + '/persistedFaces')
uri.query = URI.encode_www_form({
})
Dir.foreach('./angela_pics') do |item|
    next if item == '.' or item == '..'
    request = Net::HTTP::Post.new(uri.request_uri)
    # Request headers
    request['Content-Type'] = 'application/json'
    # Request headers
    request['Ocp-Apim-Subscription-Key'] = data_hash['secret_key']
    # Request body
    request.body = "{'url': 'https://github.com/DumboOctopus/secure-zone/blob/master/angela_pics/" + item.to_s + "?raw=true'}"

    response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
        http.request(request)
    end
end

sleep(60)

#PERSONGROUP PERSON ADD FACE
uri = URI('https://westcentralus.api.cognitive.microsoft.com/face/v1.0/persongroups/names/persons/' + personIds['Neil'] + '/persistedFaces')
uri.query = URI.encode_www_form({
})
Dir.foreach('./neil_pics') do |item|
    next if item == '.' or item == '..'
    request = Net::HTTP::Post.new(uri.request_uri)
    # Request headers
    request['Content-Type'] = 'application/json'
    # Request headers
    request['Ocp-Apim-Subscription-Key'] = data_hash['secret_key']
    # Request body
    request.body = "{'url': 'https://github.com/DumboOctopus/secure-zone/blob/master/neil_pics/" + item.to_s + "?raw=true'}"

    response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
        http.request(request)
    end
end

sleep(60)


#PERSONGROUP PERSON ADD FACE
uri = URI('https://westcentralus.api.cognitive.microsoft.com/face/v1.0/persongroups/names/persons/' + personIds['Nathan'] + '/persistedFaces')
uri.query = URI.encode_www_form({
})
Dir.foreach('./nathan_pics') do |item|
    next if item == '.' or item == '..'
    request = Net::HTTP::Post.new(uri.request_uri)
    # Request headers
    request['Content-Type'] = 'application/json'
    # Request headers
    request['Ocp-Apim-Subscription-Key'] = data_hash['secret_key']
    # Request body
    request.body = "{'url': 'https://github.com/DumboOctopus/secure-zone/blob/master/nathan_pics/" + item.to_s + "?raw=true'}"

    response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
        http.request(request)
    end
end

sleep(60)

#TRAIN
uri = URI('https://westcentralus.api.cognitive.microsoft.com/face/v1.0/persongroups/names/train')
uri.query = URI.encode_www_form({
})

request = Net::HTTP::Post.new(uri.request_uri)
# Request headers
request['Ocp-Apim-Subscription-Key'] = data_hash['secret_key']
# Request body
request.body = "{}"

response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
    http.request(request)
end



#IDENTIFY
uri = URI('https://westcentralus.api.cognitive.microsoft.com/face/v1.0/identify')
uri.query = URI.encode_www_form({
})

request = Net::HTTP::Post.new(uri.request_uri)
# Request headers
request['Content-Type'] = 'application/json'
# Request headers
request['Ocp-Apim-Subscription-Key'] = data_hash['secret_key']
# Request body
request.body = "{'personGroupId': 'names', 'faceIds': ['" + dictionary['Angela'][2] + "'], 'maxNumOfCandidatesReturned': 1, 'confidenceThreshold': 0.4}"

response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
    http.request(request)
end

puts personIds.key(JSON.parse(response.body)[0]['candidates'][0]['personId'])

puts personIds
