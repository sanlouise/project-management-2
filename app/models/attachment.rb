class Attachment < ActiveRecord::Base

	validates_presence_of :name, :upload
  validates_uniqueness_of :name

  validate :uploaded_file_size
  belongs_to :project

  MAX_FILE_SIZE = 5.megabytes
  attr_accessor :upload

  private

 		def upload_to_s3
      s3 = Aws::S3::Resource.new
      tenant_name = Tenant.find(Thread.current[:tenant_id]).name
      obj = s3.bucket(ENV['S3_BUCKET']).object("#{tenant_name}/#{upload.original_filename}")
      obj.upload_file(upload.path, acl:'public-read')
      self.key = obj.public_url
    end


  	def uploaded_file_size
  		return unless upload
  		errors.add(:upload "File too big. Maximum 5MB.") unless upload.size <= self.class::MAX_FILE_SIZE
  	end
  
end
