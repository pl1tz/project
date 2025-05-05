namespace :banners do
  desc "Migrate banner images from URL attributes to Active Storage attachments"
  task migrate_images: :environment do
    require 'open-uri'
    require 'uri'

    Banner.find_each do |banner|
      puts "Processing banner ##{banner.id}"

      # Process image attribute
      if banner.image.present?
        begin
          puts "Downloading image from #{banner.image}"
          file = URI.open(banner.image)
          banner.images.attach(io: file, filename: "image_#{banner.id}.jpg")
          puts "Successfully attached first image"
          banner.update_column(:image, nil)
          puts "Set image to nil"
        rescue => e
          puts "Error processing first image: #{e.message}"
        end
      end

      # Process image2 attribute
      if banner.image2.present?
        begin
          puts "Downloading image2 from #{banner.image2}"
          file = URI.open(banner.image2)
          banner.images.attach(io: file, filename: "image2_#{banner.id}.jpg")
          puts "Successfully attached second image"
          banner.update_column(:image2, nil)
          puts "Set image2 to nil"
        rescue => e
          puts "Error processing second image: #{e.message}"
        end
      end
    end

    puts "Migration completed!"
  end
end
