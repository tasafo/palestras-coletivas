json.array! @event.schedules do |schedule|
  json.user schedule.talk.users do |user|
    json.name user.name
    json.email user.email
    json.talk schedule.talk.title
  end
end
