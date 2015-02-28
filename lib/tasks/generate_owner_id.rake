namespace :db do
  namespace :pc do
    desc "Updates owner_id of talks and events"
    task :update_owner_id => :environment do
      events = Event.all
      events.each do |event|
        event.update_attribute(:owner_id, BSON::ObjectId.from_string(event.owner)) unless event.owner.blank?
      end

      talks = Talk.all
      talks.each do |talk|
        talk.update_attribute(:owner_id, BSON::ObjectId.from_string(talk.owner)) unless talk.owner.blank?
      end
    end
  end
end