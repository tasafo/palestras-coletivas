shared_examples_for "password reset email" do
  it "sets login url" do
    expect(body).to include(edit_password_reset_url(user.password_reset_token))
  end

  it "sets name" do
    expect(body).to include("Olá Paul Young,")
  end
end