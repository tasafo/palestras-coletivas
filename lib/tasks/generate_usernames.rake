namespace :db do
  namespace :pc do
    desc 'Generates usernames to users'
    task generate_usernames: :environment do
      saved_users = []

      User.all.each do |user|
        if user.username.blank?
          user.username = I18n.transliterate("@#{user.name.gsub(' ', '').gsub('@', '').underscore}").downcase
          saved = user.save

          if saved
            saved_users << "Saved user #{user.id} with username '#{user.username}'."
          else
            saved_users << "[Error] Could not save user #{user.id} with username '#{user.username}'. \
                            Please change it manually!"
          end
        else
          saved_users << "[Skip] User #{user.id} already has username '#{user.username}'"
        end
      end

      puts "Results:\nTotal of #{saved_users.size} users"
      puts saved_users.join "\n"
    end
  end
end
