# frozen_string_literal: true

class ResponsesSpec
  describe Response do
    it "the responses#create_feedback method" do
      @user = User.find_by_email("testuser@gmail.com")
      @quiz = Quiz.new({:user_id => @user.id, :which_grbas_letter => "R", :difficulty => 1, :num_questions => 1})
      @sound = Sound.find_by_id(195)
      @response = Response.create({:r_rating => 1, :reasoning => "yuh", :sound_id => @sound.id, :user_id => @user.id})
      @quiz.sounds << @sound
      @quiz.users << @user
      @quiz.responses << @response
      @quiz.save
      @response.save
      expect(@response.feedback).to eq(nil)
      @response.update(feedback: @response.create_feedback("r"))
      expect(@response.feedback).to_not eq(nil)
    end
    it "second example of responses#create_feedback method" do
      @user = User.find_by_email("testuser@gmail.com")
      @quiz = Quiz.new({:user_id => @user.id, :which_grbas_letter => "G", :difficulty => 1, :num_questions => 1})
      @sound = Sound.find_by_id(1)
      @response = Response.create({:g_rating => 3, :reasoning => "yuh", :sound_id => @sound.id, :user_id => @user.id})
      @quiz.sounds << @sound
      @quiz.users << @user
      @quiz.responses << @response
      @quiz.save
      @response.save
      expect(@response.feedback).to eq(nil)
      @response.update(feedback: @response.create_feedback("g"))
      expect(@response.feedback).to eq("Not quite. Our experts rated this voice as within normal limits or G0. The voice may not be perfect, but is it a voice that would stand out if you heard it in a public place (ie walking down a street)?")
    end
    it "third example of responses#create_feedback method" do
      @user = User.find_by_email("testuser@gmail.com")
      @quiz = Quiz.new({:user_id => @user.id, :which_grbas_letter => "G", :difficulty => 1, :num_questions => 1})
      @sound = Sound.find_by_id(6)
      @response = Response.create({:g_rating => 1, :reasoning => "yuh", :sound_id => @sound.id, :user_id => @user.id})
      @quiz.sounds << @sound
      @quiz.users << @user
      @quiz.responses << @response
      @quiz.save
      @response.save
      expect(@response.feedback).to eq(nil)
      @response.update(feedback: @response.create_feedback("g"))
      expect(@response.feedback.include?(("Yes, this is a dysphonic voice. The experts put the level at G"))).to be true
    end
  end
end
