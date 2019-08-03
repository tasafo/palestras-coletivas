records = 10

I18n.locale = 'pt-BR'

Activity.create(
  [
    { type: 'talk', description: 'Palestra', order: 1 },
    { type: 'interval', description: 'A definir', order: 2 },
    { type: 'interval', description: 'Credenciamento', order: 3 },
    { type: 'interval', description: 'Abertura', order: 4 },
    { type: 'interval', description: 'Intervalo', order: 5 },
    { type: 'interval', description: 'Lanche', order: 6 },
    { type: 'interval', description: 'Almoço', order: 7 },
    { type: 'interval', description: 'Fishbowl', order: 8 },
    { type: 'interval', description: 'Encerramento', order: 9 }
  ]
)

activity_open = Activity.find_by(order: 4)
activity_talk = Activity.find_by(order: 1)
activity_lunch = Activity.find_by(order: 6)
activity_finish = Activity.find_by(order: 9)

user = User.create(
  name: 'Fulano de Tal',
  username: 'fulano',
  email: 'fulano@mail.com',
  password: '123456',
  counter_organizing_events: 2,
  counter_presentation_events: 1,
  counter_public_talks: 2
)

user.talks.create(
  [
    {
      owner: user,
      users: [user],
      presentation_url: '',
      title: 'As novas tecnologias',
      description: 'Um pouco sobre as tecnologias do futuro',
      tags: 'tecnologias',
      to_public: true,
      counter_presentation_events: 1
    },
    {
      owner: user,
      users: [user],
      presentation_url: '',
      title: 'Ruby praticamente falando',
      description: 'A linguagem Ruby',
      tags: 'ruby',
      to_public: true
    }
  ]
)

talk = Talk.first

Event.create(
  name: 'Evento de Relações Humanas',
  edition: Date.today.year,
  description: 'Sobre o futuro da humanidade',
  stocking: 50,
  workload: 16,
  thumbnail: 'apple',
  tags: 'humanos',
  start_date: Date.today,
  end_date: Date.today + 1.day,
  deadline_date_enrollment: Date.today + 1.day,
  to_public: true,
  place: 'Praça de Encontro',
  street: 'Rua dos Pariquis, 300',
  district: 'Jurunas',
  city: 'Belém',
  state: 'Pará',
  country: 'Brasil',
  owner: user,
  users: [user]
)

event = Event.create(
  name: 'Evento de Tecnologia',
  edition: Date.today.year,
  description: 'Um evento muito legal de participar',
  stocking: 100,
  workload: 16,
  thumbnail: 'apple',
  tags: 'tecnologia, diversão',
  start_date: Date.today - 2.days,
  end_date: Date.today - 1.day,
  deadline_date_enrollment: Date.today - 1.day,
  to_public: true,
  place: 'Praça de Convenções',
  street: 'Rua dos Mundurucus, 500',
  district: 'Jurunas',
  city: 'Belém',
  state: 'Pará',
  country: 'Brasil',
  owner: user,
  users: [user],
  counter_registered_users: records,
  counter_present_users: records
)

event.schedules.create(
  [
    { day: 1, time: '09:00', activity: activity_open },
    { day: 1, time: '10:00', activity: activity_talk, talk: talk,
      was_presented: true },
    { day: 1, time: '11:30', activity: activity_lunch },
    { day: 1, time: '12:00', activity: activity_finish }
  ]
)

1.upto(records) do
  name = Faker::Name.name

  user1 = User.create(
    name: name,
    username: name.parameterize.delete('-'),
    email: Faker::Internet.email,
    password: '123456',
    counter_enrollment_events: 1,
    counter_participation_events: 1
  )

  Enrollment.create(event: event, user: user1, present: true)
end
