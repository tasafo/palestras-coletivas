json.array! @events do |event|
  json.extract! event, :name, :edition, :description, :start_date, :end_date,
                :street, :district, :state, :country
end
