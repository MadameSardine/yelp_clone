require 'rails_helper'

describe 'reviewing' do

	context 'User is logged out' do
		before do
			Restaurant.create(name: 'KFC')
		end

		it "doesn't allow users to leave a review" do
			visit '/restaurants'
			click_link 'Review KFC'
			expect(page).to have_content 'You need to sign in or sign up before continuing.'
		end

	end

	context 'User is logged in' do

		before do
			Restaurant.create(name: 'KFC')
			@user = User.create(email: 'test@test.com', password: 'password', password_confirmation: 'password')
			login_as @user
		end

		it 'allows users to leave a review using a form' do
			visit '/restaurants'
			click_link 'Review KFC'
			fill_in 'Thoughts', with: "so so"
			select '3', from: 'Rating'
			click_button 'Leave Review'
			expect(current_path).to eq '/restaurants'
			expect(page).to have_content('so so')
		end

		it "doesn't allow an user to leave more than one review per restaurant" do
			visit '/restaurants'
			click_link 'Review KFC'
			fill_in 'Thoughts', with: "so so"
			select '3', from: 'Rating'
			click_button 'Leave Review'
			expect(page).not_to have_content('Review KFC')
		end
	end

end