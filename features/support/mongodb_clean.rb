After do |scenario|
  puts "cleaning mongodb...."
  Mongoid.database.collections.each do |collection|
    unless collection.name =~ /^system\./
      collection.remove
    end
  end
  puts "finished cleaning mongodb after \"#{scenario.name}\"."
end