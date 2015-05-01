require "spec_helper"

describe Oembed do
  context "returns" do
    context "slideshare presentation" do
      it "valid" do
        oembed = Oembed.new "http://pt.slideshare.net/luizsanches/ruby-praticamente-falando"

        expect(oembed.open_presentation).to be_truthy
      end

      it "invalid" do
        stub_request(:get, /slideshare.net/).
          with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
          to_return(
            :status => 404,
            :body => '',
            :headers => {}
          )

        oembed = Oembed.new "http://pt.slideshare.net/luizsanches/nononono"

        expect(oembed.open_presentation).to be_falsey
      end
    end

    context "speakerdeck presentation" do
      it "valid" do
        oembed = Oembed.new "https://speakerdeck.com/luizsanches/ruby-praticamente-falando"

        expect(oembed.open_presentation).to be_truthy
      end

      it "invalid" do
        stub_request(:get, /speakerdeck.com/).
          with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
          to_return(
            :status => 404,
            :body => '',
            :headers => {}
          )

        oembed = Oembed.new "https://speakerdeck.com/luizsanches/nononono"

        expect(oembed.open_presentation).to be_falsey
      end
    end

    context "prezi presentation" do
      it "valid" do
        oembed = Oembed.new "https://prezi.com/ggblugsq5p7h/soa-introducao/"

        expect(oembed.open_presentation).to be_truthy
      end

      it "invalid" do
        stub_request(:get, /prezi.com/).
          with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
          to_return(
            :status => 404,
            :body => '',
            :headers => {}
          )

        oembed = Oembed.new "https://prezi.com/nononononono/nonononono/"

        expect(oembed.open_presentation).to be_falsey
      end
    end

    context "youtube video" do
      it "valid" do
        oembed = Oembed.new "http://www.youtube.com/watch?v=wGe5agueUwI"

        expect(oembed.show_video).to be_truthy
      end

      it "invalid" do
        stub_request(:get, /youtube.com/).
          with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
          to_return(
            :status => 404,
            :body => '',
            :headers => {}
          )

        oembed = Oembed.new "http://www.youtube.com/invalid"

        expect(oembed.show_video).to be_falsey
      end
    end

    context "vimeo video" do
      it "valid" do
        oembed = Oembed.new "https://vimeo.com/46879129"

        expect(oembed.show_video).to be_truthy
      end

      it "invalid" do
        stub_request(:get, /vimeo.com/).
          with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
          to_return(
            :status => 404,
            :body => '',
            :headers => {}
          )

        oembed = Oembed.new "https://vimeo.com/invalid"

        expect(oembed.show_video).to be_falsey
      end
    end
  end
end