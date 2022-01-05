records = 20
I18n.locale = 'pt-BR'
Faker::Config.locale = I18n.locale

user = User.create(name: 'Fulano de Tal', username: 'fulano',
                   email: 'fulano@mail.com', password: '123456')

talker = User.create(name: 'Erasmo Carlos', username: 'erasmos',
                     email: 'erasmo@mail.com', password: '123456')

organizer = User.create(name: 'Alberto Roberto', username: 'alberto',
                        email: 'alberto@mail.com', password: '123456')

Event.create(
  name: 'Evento de Tecnologia',
  edition: Date.today.year,
  description: '<p>Um evento muito legal de participar</p>',
  stocking: 100,
  workload: 16,
  tags: 'tecnologia, diversão',
  start_date: Date.today,
  end_date: Date.today + 1.day,
  deadline_date_enrollment: Date.today,
  to_public: true,
  place: 'Praça de Convenções',
  street: 'Rua dos Mundurucus, 500',
  district: 'Jurunas',
  city: 'Belém',
  state: 'Pará',
  country: 'Brasil',
  owner: user,
  users: [user]
)

Talk.create(title: Faker::ProgrammingLanguage.name,
            description: Faker::Lorem.sentence,
            owner: user, users: [user], tags: 'informática, ensino', to_public: true)

1.upto(records) do
  Talk.create(title: Faker::ProgrammingLanguage.name,
              description: Faker::Lorem.sentence,
              owner: user, users: [user, talker], to_public: true,
              tags: Faker::Lorem.words.join(' '))
end

1.upto(records) do |number|
  date = Date.today - (number + 1).day

  Event.create(
    name: Faker::Company.industry,
    edition: Date.today.year,
    description: "<p>#{Faker::Lorem.paragraph_by_chars}</p>",
    stocking: 50,
    workload: 8,
    tags: Faker::Lorem.words.join(' '),
    start_date: date,
    end_date: date,
    deadline_date_enrollment: date,
    to_public: true,
    online: true,
    owner: user,
    users: [user, organizer]
  )
end

event = Event.first
talk = Talk.first
talk2 = Talk.last

event.schedules.create(
  [
    { day: 1, time: '09:00', description: 'Abertura' },
    { day: 1, time: '10:00', description: 'Palestra', talk: talk },
    { day: 1, time: '11:00', description: 'Palestra', talk: talk2 },
    { day: 1, time: '12:00', description: 'Lanche' },
    { day: 1, time: '18:00', description: 'Encerramento' }
  ]
)

1.upto(records) do
  name = "#{Faker::Name.first_name} #{Faker::Name.last_name}"
  username = "#{name.split.first.parameterize}#{name.split.last.parameterize}"
  email = "#{username}@mail.com"

  user = User.create(name: name, username: username, email: email, password: '123456')

  enrollment = user.enrollments.create(event: event)
  enrollment.update(present: true)

  user.watch_talk(talk)

  comment_params = { commentable: event, user: user, body: Faker::Lorem.paragraph }
  Comment.new.comment_on(**comment_params)
end
