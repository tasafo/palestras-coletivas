FactoryBot.define do
  factory :user do
    password { 'testdrive' }
    password_confirmation { 'testdrive' }
    password_reset_token { SecureRandom.urlsafe_base64 }
    password_reset_sent_at { Time.now }

    trait :paul do
      name { 'Paul Young' }
      username { '@pyoung' }
      email { 'paul@example.org' }
      avatar { File.new(ImageFile.asset('avatar.jpg')) }
    end

    trait :billy do
      name { 'Billy' }
      username { '@billy' }
      email { 'billy@example.org' }
      password_reset_token { SecureRandom.urlsafe_base64 }
      password_reset_sent_at { 5.hours.ago }
    end

    trait :luis do
      name { 'Luis Miguel' }
      username { '@lmiguel' }
      email { 'luiz@example.org' }
      gravatar_photo { nil }
    end

    trait :random do
      sequence(:name)  { |n| "John #{n}" }
      sequence(:username) { |n| "@john#{n}" }
      sequence(:email) { |n| "john#{n}@example.org" }
      password_reset_token { SecureRandom.urlsafe_base64 }
      password_reset_sent_at { 5.hours.ago }
    end
  end

  factory :comment do
    trait :talk do
      commentable { build :talk }
      body        { 'Gostei!' }
      user        { build :user, :luis }
    end
  end

  factory :talk do
    presentation_url { 'https://slideshare.net/luizsanches/compartilhe' }
    title { 'Compartilhe' }
    description { 'Essa palestra fala sobre compartilhamento de informações' }
    tags { 'tecnologia, compartilhamento, informação' }
    to_public { true }
    code { '16635025' }

    factory :other_talk do
      presentation_url { 'https://slideshare.net/luizsanches/ruby-praticamente-falando' }
      title { 'Ruby praticamente falando' }
      description { 'Fala sobre ruby e rails' }
      code { '8521445' }
      tags { 'ruby,rails' }
      to_public { false }
    end

    factory :another_talk do
      presentation_url { '' }
      title { 'A história da informática' }
      description { 'Um história comovente da era da informática' }
      tags { 'tecnologia; informática' }
      thumbnail { '' }
      code { '' }
      to_public { true }
    end

    factory :speakerdeck_talk do
      presentation_url { 'https://speakerdeck.com/luizsanches/ruby-praticamente-falando' }
      title { 'Ruby - praticamente falando' }
      description { 'Indrodução à linguagem Ruby' }
      code { '920aa870aa9d0130a293521e21bc27c7' }
      tags { 'ruby;programação' }
      to_public { true }
    end

    factory :prezi_talk do
      presentation_url { 'https://prezi.com/ggblugsq5p7h/soa-introducao/' }
      title { 'SOA - Introdução' }
      description { 'SOA - Introdução' }
      code { 'ggblugsq5p7h' }
      tags { 'soa arquitetura sistemas' }
      to_public { true }
    end
  end

  factory :event do
    trait :tasafoconf do
      name { 'Tá Safo Conf 2012' }
      description { 'Evento de tecnologia com sua 1ª edição na região' }
      stocking { 100 }
      tags { 'tecnologia, agilidade, gestão' }
      start_date { '05/06/2012' }
      end_date { '06/06/2012' }
      deadline_date_enrollment { '06/06/2012' }
      online { true }
      to_public { true }
      coordinates { [-48.4945471, -1.4714916] }
    end
  end

  factory :schedule do
    day { 1 }

    trait :abertura do
      time { '08:00' }
      description { 'Abertura' }
    end

    trait :palestra do
      time { '09:00' }
      description { 'Palestra' }
    end

    trait :intervalo do
      time { '10:00' }
      description { 'Intervalo' }
    end
  end

  factory :enrollment do
  end

  factory :external_event do
    trait :rubyconf do
      name { 'Ruby Conf 2011' }
      place { 'São Paulo, SP' }
      date { '01/01/2011' }
      url { 'https://rubyconf.com' }
    end

    trait :fisl do
      name { 'FISL 12' }
      place { 'Porto Alegre, RS' }
      date { '02/02/2012' }
      url { 'https://fisl.org.br' }
    end
  end

  factory :vote do
  end
end
