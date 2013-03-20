FactoryGirl.define do
  factory :user do
    trait :paul do
      name "Paul Young"
      email "paul@example.org"
      password "testdrive"
      password_confirmation "testdrive"
    end

    trait :billy do
      name "Billy Paul"
      email "billy@example.org"
      password "testdrive"
      password_confirmation "testdrive"
    end

    trait :luis do
      name "Luis Miguel"
      email "luizgrsanches@gmail.com"
      password "testdrive"
      password_confirmation "testdrive"
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
end