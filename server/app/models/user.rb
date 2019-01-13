require "google/cloud/storage"

class User < ApplicationRecord
  has_many :entries
  


end
