Geocoder.configure(lookup: :test)

Geocoder::Lookup::Test.set_default_stub(
  [
    {
      'geometry' => { 'location' => { 'lat' => -1.4714916, 'lng' => -48.4945471 } },
      'address' => 'Rua dos Caripunas, 400, Jurunas, Belém, Pará, Brasil',
      'state' => 'Pará',
      'state_code' => 'PA',
      'country' => 'Brazil',
      'country_code' => 'BR'
    }
  ]
)
