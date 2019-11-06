require 'rails_helper'

describe "As a regular User" do
  describe "When I visit my profile page" do
    before :each do
      @user = User.create(name: 'Patti', address: '953 Sunshine Ave', city: 'Honolulu', state: 'Hawaii', zip: '96701', email: 'pattimonkey34@gmail.com', password: 'banana')
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
    end

    it "Displays my profile data and a link to edit my profile." do
      visit "/profile/#{@user.id}"

      expect(page).to_not have_link('My Orders')
      expect(page).to have_content('Hello, Patti!')
      expect(page).to have_content('953 Sunshine Ave')
      expect(page).to have_content('City: Honolulu')
      expect(page).to have_content('State: Hawaii')
      expect(page).to have_content('Zip Code: 96701')
      expect(page).to have_content('E-mail: pattimonkey34@gmail.com')
      expect(page).to have_link('Edit Profile')
      click_link 'Edit Profile'

      expect(current_path).to eq("/profile/#{@user.id}/edit")
    end

    it 'can link to order show page' do
      order_1 = @user.orders.create!(name: 'Richy Rich', address: '102 Main St', city: 'NY', state: 'New York', zip: '10221' )
      order_2 = @user.orders.create!(name: 'Alice Wonder', address: '346 Underground Blvd', city: 'NY', state: 'New York', zip: '10221' )
      order_3 = @user.orders.create!(name: 'Sonny Moore', address: '87 Electric Ave', city: 'NY', state: 'New York', zip: '10221' )


      visit "/profile/#{@user.id}"

      click_link 'My Orders'

      expect(current_path).to eq("/profile/orders")
    end

    it "I can see all of my addresses" do
      other_address = @user.addresses.create!(address: '505 West St', city: 'Denver', state: 'Colorado', zip: '10225' )

      visit "/profile/#{@user.id}"

      expect(page).to have_content('953 Sunshine Ave')
      expect(page).to have_content('City: Honolulu')
      expect(page).to have_content('State: Hawaii')
      expect(page).to have_content('Zip Code: 96701')

      expect(page).to have_content('505 West St')
      expect(page).to have_content('City: Denver')
      expect(page).to have_content('State: Colorado')
      expect(page).to have_content('Zip Code: 10225')

    end
  end
end
