json.status "Success"
json.extract! @user, :id, :first_name, :last_name, :picture_url, :created_at, :updated_at
