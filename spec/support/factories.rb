FactoryGirl.define do
  factory :user do
    password "testdrive"
    password_confirmation "testdrive"
    password_reset_token SecureRandom.urlsafe_base64
    password_reset_sent_at Time.zone.now

    trait :paul do
      name "Paul Young"
      email "paul@example.org"
    end

    trait :billy do
      name "Billy Paul"
      email "billy@example.org"
      password_reset_token SecureRandom.urlsafe_base64
      password_reset_sent_at 5.hours.ago
    end

    trait :luis do
      name "Luis Miguel"
      email "luizgrsanches@gmail.com"
    end

    trait :random do
      sequence(:name)  { |n| "John #{n}" }
      sequence(:email) { |n| "john#{n}@example.org" }
      password_reset_token SecureRandom.urlsafe_base64
      password_reset_sent_at 5.hours.ago
    end
  end

  factory :comment do
    trait :talk do
      commentable { build :talk }
      body        { "Gostei!" }
      user        { build :user, :luis }
    end
  end

  factory :talk do
    presentation_url "http://www.slideshare.net/luizsanches/compartilhe"
    title "Compartilhe"
    description "Essa palestra fala sobre compartilhamento de informações"
    tags "tecnologia, compartilhamento, informação"
    to_public true
    thumbnail "//cdn.slidesharecdn.com/ss_thumbnails/compartilhe-130219192210-phpapp02-thumbnail.jpg?1361323471"
    code "16635025"

    factory :other_talk do
      presentation_url "http://www.slideshare.net/luizsanches/ruby-praticamente-falando"
      title "Ruby praticamente falando"
      description "Fala sobre ruby e rails"
      thumbnail "//cdn.slidesharecdn.com/ss_thumbnails/ruby-praticamente-falando-v1-1-110706064112-phpapp01-thumbnail.jpg?1309952602"
      code "8521445"
      tags "ruby, rails"
      to_public false
    end

    factory :another_talk do
      title "A história da informática"
      description "Um história comovente da era da informática"
      tags "tecnologia, informática"
      thumbnail ""
      code ""
      to_public true
    end

    factory :speakerdeck_talk do
      presentation_url "https://speakerdeck.com/luizsanches/ruby-praticamente-falando"
      title "Ruby - praticamente falando"
      description "Indrodução à linguagem Ruby"
      thumbnail "https://speakerd.s3.amazonaws.com/presentations/920aa870aa9d0130a293521e21bc27c7/thumb_slide_0.jpg"
      code "920aa870aa9d0130a293521e21bc27c7"
      tags "ruby, programação"
      to_public true
    end
  end

  factory :event do
    trait :tasafoconf do
      name "Tá Safo Conf"
      edition "2012"
      description "Evento de tecnologia que vem com sua 1ª edição na região"
      stocking 100
      tags "tecnologia, agilidade, gestão"
      start_date "05/06/2012"
      end_date "06/06/2012"
      deadline_date_enrollment "06/06/2012"
      place "Centro de Convenções do Jurunas"
      street "Rua dos Caripunas, 800"
      district "Jurunas"
      city "Belém"
      state "Pará"
      country "Brasil"
      to_public true
    end
  end

  factory :activity do
    trait :palestra do
      type "talk"
      description "Palestra"
      order 1
    end

    trait :abertura do
      type "interval"
      description "Abertura"
      order 2
    end

    trait :intervalo do
      type "interval"
      description "Intervalo"
      order 3
    end

    trait :lanche do
      type "interval"
      description "Lanche"
      order 4
    end
  end

  factory :schedule do
    day 1

    trait :abertura do
      time "08:00"
      activity { create(:activity, :abertura) }
    end

    trait :palestra do
      time "09:00"
      activity { create(:activity, :palestra) }
    end

    trait :intervalo do
      time "10:00"
      activity { create(:activity, :intervalo) }
    end
  end

  factory :enrollment do

  end

  factory :external_event do
    trait :rubyconf do
      name "Ruby Conf 2011"
      place "São Paulo, SP"
      date "01/01/2011"
      url "http://rubyconf.com"
    end

    trait :fisl do
      name "FISL 12"
      place "Porto Alegre, RS"
      date "02/02/2012"
      url "http://fisl.org.br"
    end
  end

  factory :vote do

  end
end
