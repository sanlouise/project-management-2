class Attachment < ActiveRecord::Base

	validates_presence_of :name, :upload
  validates_uniqueness_of :name

  validate :uploaded_file_size
  belongs_to :project

  MAX_FILE_SIZE = 5.megabytes
  attr_accessor :upload

  private

  	def uploaded_file_size
  		return unless upload
  		errors.add(:upload "File too big. Maximum 5MB.")
  	end
  
end
