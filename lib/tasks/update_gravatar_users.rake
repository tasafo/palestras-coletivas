namespace :db do
  namespace :pc do
    desc 'Updates gravatar users'
    task update_gravatar_users: :environment do
      users = User.all
      users_count = users.count

      users.each_with_index do |user, index|
        puts "Updating gravatar from user number #{index + 1} / #{users_count}"

        photo = Gravatar.new(user.email).thumbnail_url

        user.update(gravatar_photo: photo) if photo
      end
    end
  end
end
