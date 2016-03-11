json.array! @enrollments do |enrollment|
  json.name enrollment.user.name
  json.email enrollment.user.email
end
