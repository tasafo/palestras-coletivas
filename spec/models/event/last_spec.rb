require 'spec_helper'

describe Event, ".last" do
  let(:user) { create(:user, :paul) }

  before do
    5.times do |i|
      create(:event, :tasafoconf, name: "teste_#{i}", owner: user, start_date: Date.tomorrow, end_date: Date.tomorrow)
    end
  end

  it "returns n last events" do
    events = Event.last_events(3).to_a
    count = 5
    
    3.times do |i|
      count = count - 1
      expect(events[i][:name]).to eql("teste_#{count}")
    end
  end

end