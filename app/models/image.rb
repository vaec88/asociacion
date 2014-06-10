class Image < ActiveRecord::Base
  attr_accessible :img_path, :img_path_content_type, :img_path_file_size, :construction_id
  belongs_to :construction

  validates :img_path,
            :presence => true
          
  has_attached_file :img_path,
    :storage => :dropbox,
    :dropbox_credentials => Rails.root.join("config/dropbox.yml"),
    
    :default_url => "https://dl.dropboxusercontent.com/u/246482361/images/constructions/no_image_construction.png",
    :path => "images/constructions/:construction_id/:basename_:style.:extension",
    :url => "images/constructions/:construction_id/:basename_:style.:extension",
  
    :default_style => :small,
	    :styles => {
	      :thumb=> "200x200#",
	      :small=> "250x250>"}
	  # Validaciones de Paperclip
	  validates_attachment_size :img_path, :less_than => 2.megabytes
	  validates_attachment_content_type :img_path, :content_type => ['image/jpeg', 'image/png']

#  validate :validate_image_size
#
#  def validate_image_size
#    if self.img_path.file? && self.img_path.size > 2.megabytes
#      errors.add(:img_path," ... Your error message")
#    end
#  end
end