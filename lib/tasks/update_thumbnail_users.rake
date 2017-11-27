namespace :db do
  namespace :pc do
    desc "Updates thumbnail users"
    task :update_thumbnail_users => :environment do
      users_count = User.all.count
      count = 1

      User.all.each do |user|
        gravar = false

        puts "Atualizando thumbnail do usuário de n. #{count} / #{users_count}"

        puts "> obtendo dados de gravatar.com"
        photo = Gravatar.new(user.email).fields.thumbnail_url

        if photo
          gravar = true
          user.gravatar_photo = photo
        end

        user.save if gravar

        count += 1
      end
    end
  end
end
