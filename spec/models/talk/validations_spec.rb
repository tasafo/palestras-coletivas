require 'spec_helper'

describe Talk, 'validations', type: :model do
  context 'when valid data' do
    let!(:user) { create(:user, :paul) }
    let!(:talk) { create(:talk, users: [user], owner: user) }

    it 'accepts valid attributes' do
      expect(talk).to be_valid
    end
  end

  it 'requires title' do
    talk = Talk.create(title: nil)

    expect(talk.errors[:title].size).to eq(1)
  end

  it 'requires description' do
    talk = Talk.create(description: nil)

    expect(talk.errors[:description].size).to eq(1)
  end

  it 'requires tags' do
    talk = Talk.create(tags: nil)

    expect(talk.errors[:tags].size).to eq(1)
  end

  it 'requires owner' do
    talk = Talk.create(owner: nil)

    expect(talk.errors[:owner].size).to eq(1)
  end
end
