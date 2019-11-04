require 'rails_helper'

describe User do
  describe 'relationships' do
    it { should have_many :orders}
    it { should belong_to(:merchant).optional }
  end
  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :address }
    it { should validate_presence_of :city }
    it { should validate_presence_of :state }
    it { should validate_presence_of :zip }
    it { should validate_presence_of :email }
    it { should validate_uniqueness_of :email }
    it { should validate_presence_of :password }
  end

  describe "instance methods" do
    it 'role_upgrade' do
      meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      user = User.create(name: 'Joey', address: '76 Pizza Place', city: 'Brooklyn', state: 'New York', zip: '10231', email: 'estelles_best_actor@gmail.com', password: 'letseat')

      expect(user.role).to eq("default")
      user.role_upgrade(meg.id, 1)
      expect(user.role).to eq("merchant_employee")
    end
    it 'account_activate' do
      user_1 = User.create!(name: 'Richy Rich', address: '102 Main St', city: 'NY', state: 'New York', zip: '10221', email: "young_money99@gmail.com", password: "momoneymoprobz", is_active: false)
      user_1.toggle_active_status
      user_1.reload
      expect(user_1.is_active).to eq(true)

      user_2 = User.create!(name: 'Alice Wonder', address: '346 Underground Blvd', city: 'NY', state: 'New York', zip: '10221', email: "alice_in_the_sky@gmail.com", password: "cheshirecheezin")
      user_2.toggle_active_status
      user_2.reload
      expect(user_2.is_active).to eq(false)
    end
  end


  describe 'roles' do
    it 'can be created as a regular user' do
      user = User.create(name: 'Patti', address: '953 Sunshine Ave', city: 'Honolulu', state: 'Hawaii', zip: '96701', email: 'pattimonkey34@gmail.com', password: 'banana')

      expect(user.role).to eq('default')
      expect(user.default?).to be_truthy
    end

    it 'can be created as a merchant employee' do
      meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      user = meg.users.create(name: 'Joey', address: '76 Pizza Place', city: 'Brooklyn', state: 'New York', zip: '10231', email: 'estelles_best_actor@gmail.com', password: 'letseat', role: 1)

      expect(user.role).to eq('merchant_employee')
      expect(user.merchant_employee?).to be_truthy
    end

    it 'can be created as a merchant admin' do
      meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)

      user = meg.users.create(name: 'Monica', address: '45 Squeaky Clean St', city: 'Portland', state: 'Maine', zip: '12341', email: 'number_one_chef@gmail.com', password: 'chandlerbing', role: 2)

      expect(user.role).to eq('merchant_admin')
      expect(user.merchant_admin?).to be_truthy
    end

    it 'can be created as an admin' do

      user = User.create(name: 'Ross', address: '56 HairGel Ave', city: 'Las Vegas', state: 'Nevada', zip: '65041', email: 'dinosaurs_rule@gmail.com', password: 'rachel', role: 3)

      expect(user.role).to eq('admin')
      expect(user.admin?).to be_truthy
    end
  end
end
