require 'spec_helper'

describe Event, 'validations' do
  context 'when valid data' do
    let!(:user) { create(:user, :paul) }
    let!(:other_user) { create(:user, :billy) }
    let!(:event) do
      create(
        :event,
        :tasafoconf,
        users: [user, other_user],
        owner: user
      )
    end

    it 'accepts valid attributes' do
      expect(event).to be_valid
    end
  end

  it 'requires name' do
    event = Event.create(name: nil)

    expect(event.errors[:name].size).to eq(1)
  end

  it 'requires edition' do
    event = Event.create(edition: nil)

    expect(event.errors[:edition].size).to eq(1)
  end

  it 'requires tags' do
    event = Event.create(tags: nil)

    expect(event.errors[:tags].size).to eq(1)
  end

  it 'requires start date' do
    event = Event.create(start_date: nil)

    expect(event.errors[:start_date].size).to eq(1)
  end

  it 'requires end date' do
    event = Event.create(end_date: nil)

    expect(event.errors[:end_date].size).to eq(1)
  end

  it 'requires deadline date enrollment' do
    event = Event.create(deadline_date_enrollment: nil)

    expect(event.errors[:deadline_date_enrollment].size).to eq(1)
  end

  it 'requires owner' do
    event = Event.create(owner: nil)

    expect(event.errors[:owner].size).to eq(1)
  end

  it 'requires stocking' do
    event = Event.create(stocking: nil)

    expect(event.errors[:stocking].size).to eq(1)
  end
end
