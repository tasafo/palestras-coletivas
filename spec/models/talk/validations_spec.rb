require "spec_helper"

describe Talk, "validations" do 
  it "accepts valid attributes" do
    user = User.create({
      :name => "Luiz Sanches",
      :email => "luiz@example.org",
      :password => "teste",
      :password_confirmation => "teste"
    })

    talk = Talk.new(
      :url => "http://www.slideshare.net/luizsanches/compartilhe",
      :title => "Compartilhe!",
      :description => "Palestra que fala sobre o compartilhamento de conhecimento na era da informação",
      :tags => "conhecimento, compartilhamento",
      :thumbnail => "cdn.slidesharecdn.com/ss_thumbnails/compartilhe-130219192210-phpapp02-thumbnail.jpg?1361323471",
      :code => "16635025",
      :public => true,
      :user => user
    );

    expect(talk).to be_valid
  end

  it "requires title" do
    talk = Talk.create(:title => nil)

    expect(talk).to have(1).error_on(:title)
  end

  it "requires description" do
    talk = Talk.create(:description => nil)

    expect(talk).to have(1).error_on(:description)
  end

  it "requires tags" do
    talk = Talk.create(:tags => nil)

    expect(talk).to have(1).error_on(:tags)
  end

  it "requires user" do
    talk = Talk.create(:user => nil)

    expect(talk).to have(1).error_on(:user)
  end
end