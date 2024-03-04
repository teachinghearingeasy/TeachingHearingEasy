require 'spec_helper'
require 'rails_helper'
class UsersSpec
  describe User do
    describe "Create simple user" do
      it "should respond to the create method" do
        expect(User).to receive(:create).with({:email => "valid@email.com", :password => "Password!1", :password_confirmation => "Password!1", :name => "Valid Name", :music_experience => "0", :clinical_experience => "0", :general_education => "0", :access_level => "Student"})
        User.create({:email => "valid@email.com", :password => "Password!1", :password_confirmation => "Password!1", :name => "Valid Name", :music_experience => "0", :clinical_experience => "0", :general_education => "0", :access_level => "Student"})
      end

      it "should create a valid user using the create method" do
        user = User.create({:email => "valid@email.com", :password => "Password!1", :password_confirmation => "Password!1", :name => "Valid Name", :music_experience => "0", :clinical_experience => "0", :general_education => "0", :access_level => "Student"})
        expect(user.email).to eq("valid@email.com")
        expect(user.password).to eq("Password!1")
        expect(user.name).to eq("Valid Name")
        expect(user.music_experience).to eq("0")
        expect(user.clinical_experience).to eq("0")
        expect(user.general_education).to eq("0")
        expect(user.access_level).to eq("Student")
      end
    end
    describe "Invalid inputs during user creation" do
      describe "Invalid password creation" do
        it "should return false when :password does not match :password_confirmation" do
          user = User.create({:email => "valid@email.com", :password => "Password!1", :password_confirmation => "Password!11", :name => "Valid Name", :music_experience => "0", :clinical_experience => "0", :general_education => "0", :access_level => "Student"})
          expect(user.valid?).to be false
        end
        it "should return false when :password is not at least 8 chars long" do
          user = User.create({:email => "valid@email.com", :password => "Pass12!", :password_confirmation => "Pass12!", :name => "Valid Name", :music_experience => "0", :clinical_experience => "0", :general_education => "0", :access_level => "Student"})
          expect(user.valid?).to be false
        end
        it "should return false when the :password is nil" do
          user = User.create({:email => "valid@email.com", :password => nil, :password_confirmation => nil, :name => "Valid Name", :music_experience => "0", :clinical_experience => "0", :general_education => "0", :access_level => "Student"})
          expect(user.valid?).to be false
        end
        it "should return false when the :password_confirmation is nil" do
          user = User.create({:email => "valid@email.com", :password => "Password!1", :password_confirmation => nil, :name => "Valid Name", :music_experience => "0", :clinical_experience => "0", :general_education => "0", :access_level => "Student"})
          expect(user.valid?).to be false
        end
      end
    end
  end
end