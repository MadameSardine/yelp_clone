require 'rails_helper'

describe 'User management' do

	context 'User not signed in and on the homepage' do

		it "should see a 'Sign in' link and and 'Sign up' link" do
			visit '/'
			expect(page).to have_link('Sign in')
			expect(page).to have_link ('Sign up')
		end

		it "should not see 'Sign out' link" do
			visit '/'
			expect(page).not_to have_link('Sign out')
		end
	end

	context 'User signed in on the homepage' do

		before do
			@user = User.create(email: 'test@test.com', password: 'password', password_confirmation: 'password')
      login_as @user
		end

		it "should see a 'Sign out' link" do
			visit '/'
			expect(page).to have_link('Sign out')
		end

		it "should not see a 'Sign in' link and a 'Sign up' link" do
			visit '/'
			expect(page).not_to have_link('Sign in')
			expect(page).not_to have_link('Sign up')
		end
	end

end


