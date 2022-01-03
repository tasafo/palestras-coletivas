require 'spec_helper'

describe Schedule, 'validations' do
  context 'when valid data' do
    let!(:user) { create(:user, :paul) }
    let!(:event) { create(:event, :tasafoconf, users: [user], owner: user) }
    let!(:schedule) { create(:schedule, :abertura, event: event) }

    it 'accepts valid attributes' do
      expect(schedule).to be_valid
    end
  end

  it 'requires day' do
    schedule = Schedule.create(day: nil)

    expect(schedule.errors[:day].size).to eq(1)
  end

  it 'requires time' do
    schedule = Schedule.create(time: nil)

    expect(schedule.errors[:time].size).to eq(2)
  end

  it 'requires event' do
    schedule = Schedule.create(event: nil)

    expect(schedule.errors[:event].size).to eq(1)
  end
end
