WebMock.disable_net_connect!(allow_localhost: true)

RSpec.configure do |config|
  config.after(:suite) do
    WebMock.disable_net_connect!(allow: 'codeclimate.com')
  end

  config.before(:each) do
    stub_request(:any, 'www.example.com')

    stub_request(:get, /gravatar.com/)
      .with(headers: { 'Accept' => '*/*', 'User-Agent' => 'Ruby' })
      .to_return(
        status: 200,
        body: '<response>
                    <entry>
                      <profileUrl>https://gravatar.com/luizsanches</profileUrl>
                      <thumbnailUrl>/assets/without_avatar.jpg</thumbnailUrl>
                      <aboutMe>about me</aboutMe>
                      <currentLocation>Belém - Pará - Brasil</currentLocation>
                    </entry>
                  </response>',
        headers: { 'Content-Type' => 'application/xml; charset=utf-8' }
      )

    stub_request(:get, /slideshare.net/)
      .with(headers: { 'Accept' => '*/*', 'User-Agent' => 'Ruby' })
      .to_return(
        status: 200,
        body: '<oembed>
                    <slideshow-id type="integer">16635025</slideshow-id>
                    <title>Compartilhe!</title>
                    <thumbnail>/assets/without_presentation.jpg</thumbnail>
                  </oembed>',
        headers: { 'Content-Type' => 'application/xml; charset=utf-8' }
      )

    stub_request(:get, /speakerdeck.com/)
      .with(headers: { 'Accept' => '*/*', 'User-Agent' => 'Ruby' })
      .to_return(
        status: 200,
        body: '{"title": "Titulo", "html": "<iframe src=\"//speakerdeck.com/player/920aa870aa9d0130a293521e21bc27c7\" style=\"border:0;\"><\/iframe>"}',
        headers: { 'Content-Type' => 'application/json; charset=utf-8' }
      )

    stub_request(:get, /prezi.com/)
      .with(headers: { 'Accept' => '*/*', 'User-Agent' => 'Ruby' })
      .to_return(
        status: 200,
        body: '{"presentation": {"oid": "7uq1mhqnclzn", "title": "Titulo", "thumb_url": "/assets/without_presentation.jpg", "description": "description"}}',
        headers: { 'Content-Type' => 'application/json; charset=utf-8' }
      )

    stub_request(:get, /youtube.com/)
      .with(headers: { 'Accept' => '*/*', 'User-Agent' => 'Ruby' })
      .to_return(
        status: 200,
        body: '{"title": "Titulo", "html": "<iframe src=\"\/assets\/without_presentation.jpg\"><\/iframe>"}',
        headers: { 'Content-Type' => 'application/json; charset=utf-8' }
      )

    stub_request(:get, /vimeo.com/)
      .with(headers: { 'Accept' => '*/*', 'User-Agent' => 'Ruby' })
      .to_return(
        status: 200,
        body: '{"title": "Titulo", "html": "<iframe src=\"/\assets\/without_presentation.jpg\"><\/iframe>"}',
        headers: { 'Content-Type' => 'application/json; charset=utf-8' }
      )
  end
end
