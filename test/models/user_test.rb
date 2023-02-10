require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: 'Canaan Porter', email: 'porter@mail.com', role: 'Instructor', password: 'abc123')
  end

  test 'user should be valid' do
    assert @user.valid?
  end

  test 'name should be present' do
    @user.name = '  '
    assert_not @user.valid?
  end

  test 'email should be present' do
    @user.email = '  '
    assert_not @user.valid?
  end

  test 'email should be unique' do
    dup_user = @user.dup
    @user.save
    assert_not dup_user.valid?
  end

  test 'emails should not be valid' do
    emails = %w[not_an_email mail.com only@ missing_a@dot @nothing.before more+test@mail]
    emails.each do |email|
      @user.email = email
      assert_not @user.valid?, "#{email.inspect} should not be valid"
    end
  end

  test 'emails should be valid' do
    emails = %w[example@mail.com with_underscored@osu.edu thisIsAnEmail@a.website.com.gov]
    emails.each do |email|
      @user.email = email
      assert @user.valid?, "#{email.inspect} should be valid"
    end
  end
end
