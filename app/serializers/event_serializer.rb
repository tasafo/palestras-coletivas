class EventSerializer < ApplicationSerializer
  attributes :name, :edition, :description, :start_date, :end_date, :street,
             :district, :state, :country
end
