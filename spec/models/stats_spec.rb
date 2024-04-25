# frozen_string_literal: true

class StatsSpec
  describe Stat do
    describe "#set_progress_level method" do
      it "should set the progress level of a user based on their demographic information" do
        @user = User.create({:email => "unittesters@gmail.com", :password => "Password!1", :password_confirmation => "Password!1", :name => "Student2", :music_experience => "1-2", :clinical_experience => "3-4", :general_education => "5+", :access_level => "Student"})
        @stat = Stat.create({:user_id => @user.id})
        @stat.set_progress_level
        expect(@stat.progress_level).to eq("intermediate")
      end
    end
    describe "#update_experience method" do
      it "should update progress level based on the current number of correct answers over total answers" do
        @user = User.create({:email => "unittesters@gmail.com", :password => "Password!1", :password_confirmation => "Password!1", :name => "Student2", :music_experience => "1-2", :clinical_experience => "3-4", :general_education => "5+", :access_level => "Student"})
        @stat = Stat.create({:user_id => @user.id})
        @stat.total_answers = "1/10"
        @stat.update_experience([2,10])
        expect(@stat.progress_level).to eq("beginner")
      end
      it "should not update progress level if the user has not taken any quizzes/tests" do
        @user = User.create({:email => "unittesters@gmail.com", :password => "Password!1", :password_confirmation => "Password!1", :name => "Student2", :music_experience => "1-2", :clinical_experience => "3-4", :general_education => "5+", :access_level => "Student"})
        @stat = Stat.create({:user_id => @user.id})
        @stat.set_progress_level
        @stat.update_experience([0,0])
        puts @stat.progress_level
        expect(@stat.progress_level).to eq("intermediate")
      end
    end
  end
end
