namespace :db do
  namespace :pc do
    desc 'Updates owner_id of talks and events'
    task update_owner_id: :environment do
      Event.all.each do |event|
        event.update_attribute(:owner_id, BSON::ObjectId.from_string(event.owner)) unless event.owner?
      end

      Talk.all.each do |talk|
        talk.update_attribute(:owner_id, BSON::ObjectId.from_string(talk.owner)) unless talk.owner?
      end
    end
  end
end
