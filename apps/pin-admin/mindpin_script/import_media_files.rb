require 'uuidtools'
tarball = ARGV[0]
server_dest = ARGV[1]
dest = "/tmp/shcmusic_media_files_tmp/"
file_uuids = {}

MediaFile.all.blank? || ActiveRecord::Base.connection.execute("TRUNCATE media_files")

if Category.count != 110
  puts '========================================'
  puts '====      preparing categories      ===='
  puts '========================================'

  `rails r mindpin_script/import_categories.rb`

  puts '================ done! ================='
end

creator = User.all.blank? ? User.create(
  :name => 'kaid',
  :password => '1234',
  :password_confirmation => '1234',
  :email => 'kaid@kaid.kaid'
) : User.last

puts '========================================'
puts '====        preparing files         ===='
puts '========================================'
`rm -rf #{dest}`
`mkdir -p #{dest}`
puts '======== extracting media files....'
`tar -xvf #{tarball} -C #{dest}`
`rm -rf #{dest}/._*`
puts '======== done!'
puts '================ done! ================='

file_names = Dir.entries(dest).delete_if {|x| x.match(/\A\./)}


puts '======== moving files....'
file_names.each do |f|
  fp = f.gsub('(', '\(').gsub(')', '\)').gsub(' ', '\ ').gsub("'", "\\\\'").gsub('"', '\\\\"')
  file_path = dest + fp
  uuid = UUIDTools::UUID.random_create.to_s
  file_uuids[f] = uuid

  media_file_dest = [dest, uuid, '/original/'].join

  `mkdir -p #{media_file_dest}`

  `mv #{file_path} #{media_file_dest}`

  puts "==== #{File.basename(f)} moved!"
end
puts '======== done!'


puts '======== please enter password of the file server:'
puts '==== copying files to file server....'
`rsync -v -r -P -e ssh --delete #{dest} #{server_dest}`
puts '======== done!'


def content_type(file_name)
  mime_type = MIME::Types.type_for(file_name)
  mime_type = mime_type.blank? ?
  mime_type.first.content_type :
  'application/octet-stream'
end


puts '======== seeding media file database records....'
file_uuids.each_key do |f|
  record = MediaFile.create(
    :uuid => file_uuids[f],
    :file_file_name => f,
    :place => 'edu',
    :creator => creator,
    :file_content_type => MIME::Types.type_for(f).first.content_type,
    :file_file_size => File.size(dest + file_uuids[f] + '/original/' + f),
    :file_updated_at => DateTime.now,
    :file_merged => true
  )

  puts "==== record-#{record.id} created!"
end
puts '======== done!'


puts '======== assigning media_files with categories....'
mfs = MediaFile.all[0,495]
start_number = 0
Category.leaves.each do |c|
  c.media_files.concat(mfs[start_number, 4])
  start_number += 4
end
puts '======== done!'

puts '================ done! ================='
`rm -rf #{dest}`
