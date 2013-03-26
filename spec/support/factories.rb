FactoryGirl.define do
  factory :user do
    trait :paul do
      name "Paul Young"
      email "paul@example.org"
      password "testdrive"
      password_confirmation "testdrive"
      password_reset_token SecureRandom.urlsafe_base64
      password_reset_sent_at Time.zone.now
    end

    trait :billy do
      name "Billy Paul"
      email "billy@example.org"
      password "testdrive"
      password_confirmation "testdrive"
      password_reset_token SecureRandom.urlsafe_base64
      password_reset_sent_at Time.zone.now
    end

    trait :luis do
      name "Luis Miguel"
      email "luizgrsanches@gmail.com"
      password "testdrive"
      password_confirmation "testdrive"
      password_reset_token SecureRandom.urlsafe_base64
      password_reset_sent_at Time.zone.now
    end
  end

  factory :talk do
    presentation_url "http://www.slideshare.net/luizsanches/compartilhe"
    title "Compartilhe"
    description "This is more a talk"
    tags "tecnology, computer, programming"
    to_public true
    thumbnail "//cdn.slidesharecdn.com/ss_thumbnails/compartilhe-130219192210-phpapp02-thumbnail.jpg?1361323471"
    code "16635025"

    factory :other_talk do
      presentation_url "http://www.slideshare.net/luizsanches/ruby-praticamente-falando"
      to_public false
    end
  end

  factory :group do
    trait :tasafo do
      gravatar_url "http://gravatar.com/tasafo"
      name "Tá safo!"
      tags "agilidade, gestão de projetos, engenharia de software"
      thumbnail_url "http://0.gravatar.com/avatar/c1bcd79fb1d8d4f148e3b77cc7c2c130"
    end

    trait :gurupa do
      name "GURU-PA"
      tags "ruby, rails"
    end
  end
end