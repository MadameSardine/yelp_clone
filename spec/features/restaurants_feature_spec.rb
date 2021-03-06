require 'rails_helper'

describe 'restaurants listing' do

	context 'no restaurants have been added' do

		it 'should display a prompt to add a restaurant' do
			visit '/restaurants'
			expect(page).to have_content 'No restaurants'
			expect(page).to have_link 'Add a restaurant'
		end
	end

	context 'restaurants have been added' do

		before do
			Restaurant.create(name: 'KFC')
		end

		it 'should display restaurants' do
			visit '/restaurants'
			expect(page).to have_content('KFC')
			expect(page).not_to have_content('No restaurants yet')
		end
	end

	context 'viewing restaurants' do

		before do
			@kfc = Restaurant.create(name:'KFC')
		end

		it 'lets a user view a restaurant' do
			visit '/restaurants'
			click_link 'KFC'
			expect(page).to have_content 'KFC'
			expect(current_path).to eq "/restaurants/#{@kfc.id}"
		end
	end
end

describe  'creating restaurants' do

	context 'User is logged out' do

		it "does not let you create a restaurant" do
			visit '/restaurants'
			click_link 'Add a restaurant'
			expect(page).to have_content 'You need to sign in or sign up before continuing.'
		end

	end

	context 'User is logged in' do

		before do
			@user = User.create(email: 'test@test.com', password: 'password', password_confirmation: 'password')
			login_as @user
		end

		context 'a valid restaurant' do

			it 'prompts user to fill out a form, then displays the new restaurant' do
				visit '/restaurants'
				click_link 'Add a restaurant'
				fill_in 'Name', with: 'KFC'
				click_button 'Create Restaurant'
				expect(page).to have_content('KFC')
				expect(current_path).to eq('/restaurants')
			end
		end

		context 'an invalid restaurant' do

			 it 'does not let you submit a name that is too short' do
			 	visit '/restaurants'
			 	click_link 'Add a restaurant'
			 	fill_in 'Name', with: 'kf'
			 	click_button 'Create Restaurant'
			 	expect(page).not_to have_css 'h2', text: 'kf'
			 	expect(page).to have_content 'error'
			 end

			 it 'is not valid unless it has a unique name' do
			 	Restaurant.create(name: "Moe's Tavern")
			 	restaurant = Restaurant.new(name: "Moe's Tavern")
			 	expect(restaurant).to have(1).error_on(:name)
			 end
		end
	end
end

describe 'editing restaurants' do

	context 'User is logged in' do

		before do
			@user = User.create(email: 'test@test.com', password: 'password', password_confirmation: 'password')
			@user2 = User.create(email: 'second@test.com', password: 'password', password_confirmation: 'password')
			Restaurant.create(name: 'KFC', user: @user)
		end

		it 'let a user edit a restaurant it has created' do
			login_as @user
			visit '/restaurants'
			click_link 'Edit KFC'
			fill_in 'Name', with: 'Kentucky Fried Chicken'
			click_button 'Update Restaurant'
			expect(page).to have_content 'Kentucky Fried Chicken'
			expect(current_path).to eq('/restaurants')
		end

		it "doesn't lets a user edit a restaurant it has not created" do
			login_as @user2
			visit '/restaurants'
			expect(page).not_to have_content 'Edit KFC'
		end

	end

	context 'User is logged out ' do

		before do
			Restaurant.create(name: 'KFC')
		end

		it 'lets a user edit a restaurant' do
			visit '/restaurants'
			expect(page).not_to have_content 'Edit KFC'
		end

	end
end

describe 'deleting restaurants' do

	context 'User is logged out' do

		before do
			Restaurant.create(name: 'KFC')
		end

		it "doesn't allow you to delete a restaurant" do
			visit '/restaurants'
			expect(page).not_to have_content 'Delete KFC'
		end

	end

	context 'User is logged in' do

		before do
			@user = User.create(email: 'test@test.com', password: 'password', password_confirmation: 'password')
			@user2 = User.create(email: 'second@test.com', password: 'password', password_confirmation: 'password')
				Restaurant.create(name: 'KFC', user: @user)
		end

		it 'let an user delete a restaurant he has created' do
			login_as @user
			visit '/restaurants'
			click_link 'Delete KFC'
			expect(page).not_to have_content 'KFC'
			expect(page).to have_content 'Restaurant deleted successfully'
		end

		it "doesn't allow an user delete a restaurant he has not created" do
			login_as @user2
			visit '/restaurants'
			expect(page).not_to have_content 'Delete KFC'
		end
	end
end


