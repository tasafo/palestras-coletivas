FactoryGirl.define do
  factory :user do
    name "Paul Young"
    email "paul@example.org"
    password "testdrive"
    password_confirmation "testdrive"
  end

  factory :talk do
    presentation_url "http://www.slideshare.net/luizsanches/compartilhe"
    title "Compartilhe"
    description "This is more a talk"
    tags "tecnology, computer, programming"
    to_public true
    thumbnail "//cdn.slidesharecdn.com/ss_thumbnails/compartilhe-130219192210-phpapp02-thumbnail.jpg?1361323471"
    code "16635025"
    user
  end
end