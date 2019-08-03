require 'spec_helper'

describe Event, '.in_progress?' do
  let(:user) { create(:user, :paul) }
  context 'when the event has not yet started' do
    let(:event) do
      create(:event, :tasafoconf, owner: user, start_date: Date.today + 2,
                                  end_date: Date.today + 2)
    end

    it 'returns false' do
      expect(EventPolicy.new(event).in_progress?).to be false
    end
  end

  context 'when the event is in progress' do
    let(:event) do
      create(:event, :tasafoconf, owner: user, start_date: Date.today,
                                  end_date: Date.today)
    end

    it 'returns true' do
      expect(EventPolicy.new(event).in_progress?).to be true
    end
  end

  context 'when the event has ended' do
    let(:event) do
      create(:event, :tasafoconf, owner: user, start_date: Date.today - 2,
                                  end_date: Date.today - 2)
    end

    it 'returns false' do
      expect(EventPolicy.new(event).in_progress?).to be false
    end
  end
end
