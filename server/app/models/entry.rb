class Entry < ApplicationRecord
  attr_accessor :picture

  belongs_to :user

  def self.storage_bucket
    @storage_bucket ||= begin
      config = Rails.application.config.x.settings

      storage = Google::Cloud::Storage.new project_id: config["project_id"],
                               credentials: config["keyfile"]
      storage.bucket config["gcs_bucket"]
    end
  end

  after_create :upload_image, if: :picture

  def upload_image
    cloud_dir_structure = "images/";
    server_dir_structure = "tmp/uploaded_images/"

    fname = Time.now.to_i.to_s + "uploaded_pic"
    extension = picture[11..(picture.index(";")-1)]
    fname += "." + extension
    puts picture

    File.open(server_dir_structure+fname, "wb") do |file|
        file.write(Base64.decode64(picture))
    end

    file = Entry.storage_bucket.create_file( server_dir_structure + fname, path=cloud_dir_structure + fname)

    update_columns picture_url: file.public_url
  end
  # [END upload]

  # TODO what if the image is from the Pub/Sub job and NOT in Cloud Storage!?

  # [START delete]
  before_destroy :delete_image, if: :picture_url

  def delete_image
    image_uri = URI.parse picture_url

    if image_uri.host == "#{Entry.storage_bucket.name}.storage.googleapis.com"
      # Remove leading forward slash from image path
      # The result will be the image key, eg. "cover_images/:id/:filename"
      image_path = image_uri.path.sub("/", "")

      file = Entry.storage_bucket.file image_path
      file.delete
    end
  end
  # [END delete]

  # [START update]
  before_update :update_image, if: :picture

  def update_image
    delete_image if picture_url?
    upload_image
  end

end
