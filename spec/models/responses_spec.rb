# frozen_string_literal: true

class ResponsesSpec
  describe Response do
    describe "the responses#create_feedback method" do
      it "should create feedback if the response has been correctly added to the quiz" do
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
      it "student got the rating wrong (expected G0), received feedback for incorrect rating" do
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
      it "student got the rating wrong (expected R0), received feedback for incorrect rating" do
        @user = User.find_by_email("testuser@gmail.com")
        @quiz = Quiz.new({:user_id => @user.id, :which_grbas_letter => "R", :difficulty => 1, :num_questions => 1})
        @sound = Sound.find_by_id(1)
        @response = Response.create({:r_rating => 3, :reasoning => "yuh", :sound_id => @sound.id, :user_id => @user.id})
        @quiz.sounds << @sound
        @quiz.users << @user
        @quiz.responses << @response
        @quiz.save
        @response.save
        expect(@response.feedback).to eq(nil)
        @response.update(feedback: @response.create_feedback("r"))
        expect(@response.feedback).to eq("No roughness here. A voice that is rough has an irregular wave form and sounds bumpy, unclear, or growly. The gold standard rating puts this one at R0")
      end
      it "student got the rating wrong (expected B0), received feedback for incorrect rating" do
        @user = User.find_by_email("testuser@gmail.com")
        @quiz = Quiz.new({:user_id => @user.id, :which_grbas_letter => "B", :difficulty => 1, :num_questions => 1})
        @sound = Sound.find_by_id(1)
        @response = Response.create({:b_rating => 3, :reasoning => "yuh", :sound_id => @sound.id, :user_id => @user.id})
        @quiz.sounds << @sound
        @quiz.users << @user
        @quiz.responses << @response
        @quiz.save
        @response.save
        expect(@response.feedback).to eq(nil)
        @response.update(feedback: @response.create_feedback("b"))
        expect(@response.feedback).to eq("Breathiness is caused by the escape of excess air at the glottis. The experts found this sample to be B0 or without any airy quality")
      end
      it "student got the rating wrong (expected A0), received feedback for incorrect rating" do
        @user = User.find_by_email("testuser@gmail.com")
        @quiz = Quiz.new({:user_id => @user.id, :which_grbas_letter => "A", :difficulty => 1, :num_questions => 1})
        @sound = Sound.find_by_id(1)
        @response = Response.create({:a_rating => 3, :reasoning => "yuh", :sound_id => @sound.id, :user_id => @user.id})
        @quiz.sounds << @sound
        @quiz.users << @user
        @quiz.responses << @response
        @quiz.save
        @response.save
        expect(@response.feedback).to eq(nil)
        @response.update(feedback: @response.create_feedback("a"))
        expect(@response.feedback).to eq("This voice is pretty typical when it comes to weakness. A weak voice may sound soft or under powered. Our gold standard rating didn't identify weakness for this sample, A0.")
      end
      it "student got the rating wrong (expected S0), received feedback for incorrect rating" do
        @user = User.find_by_email("testuser@gmail.com")
        @quiz = Quiz.new({:user_id => @user.id, :which_grbas_letter => "S", :difficulty => 1, :num_questions => 1})
        @sound = Sound.find_by_id(1)
        @response = Response.create({:s_rating => 3, :reasoning => "yuh", :sound_id => @sound.id, :user_id => @user.id})
        @quiz.sounds << @sound
        @quiz.users << @user
        @quiz.responses << @response
        @quiz.save
        @response.save
        expect(@response.feedback).to eq(nil)
        @response.update(feedback: @response.create_feedback("s"))
        expect(@response.feedback).to eq("Strain usually sounds like some is working too hard or the voice is tight or tense. The composite voice rating for this sample was S0 or no strain present.")
      end
      it "student got the rating wrong (expected non-zero), received feedback for incorrect rating" do
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
      it "student got the rating wrong (expected non-zero G), received feedback for incorrect rating" do
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
      it "student got the rating wrong (expected non-zero R), received feedback for incorrect rating" do
        @user = User.find_by_email("testuser@gmail.com")
        @quiz = Quiz.new({:user_id => @user.id, :which_grbas_letter => "R", :difficulty => 1, :num_questions => 1})
        @sound = Sound.find_by_id(110)
        @response = Response.create({:r_rating => 1, :reasoning => "yuh", :sound_id => @sound.id, :user_id => @user.id})
        @quiz.sounds << @sound
        @quiz.users << @user
        @quiz.responses << @response
        @quiz.save
        @response.save
        expect(@response.feedback).to eq(nil)
        @response.update(feedback: @response.create_feedback("r"))
        expect(@response.feedback.include?(("This voice definitely has roughness present. The gold standard level was R"))).to be true
      end
      it "student got the rating wrong (expected non-zero B), received feedback for incorrect rating" do
        @user = User.find_by_email("testuser@gmail.com")
        @quiz = Quiz.new({:user_id => @user.id, :which_grbas_letter => "B", :difficulty => 1, :num_questions => 1})
        @sound = Sound.find_by_id(104)
        @response = Response.create({:b_rating => 1, :reasoning => "yuh", :sound_id => @sound.id, :user_id => @user.id})
        @quiz.sounds << @sound
        @quiz.users << @user
        @quiz.responses << @response
        @quiz.save
        @response.save
        expect(@response.feedback).to eq(nil)
        @response.update(feedback: @response.create_feedback("b"))
        expect(@response.feedback.include?(("You heard the air in the sound. Our expert panel put the severity at B"))).to be true
      end
      it "student got the rating wrong (expected non-zero A), received feedback for incorrect rating" do
        @user = User.find_by_email("testuser@gmail.com")
        @quiz = Quiz.new({:user_id => @user.id, :which_grbas_letter => "A", :difficulty => 1, :num_questions => 1})
        @sound = Sound.find_by_id(6)
        @response = Response.create({:a_rating => 1, :reasoning => "yuh", :sound_id => @sound.id, :user_id => @user.id})
        @quiz.sounds << @sound
        @quiz.users << @user
        @quiz.responses << @response
        @quiz.save
        @response.save
        expect(@response.feedback).to eq(nil)
        @response.update(feedback: @response.create_feedback("a"))
        expect(@response.feedback.include?(("This voice does sound weaker than a typical voice. The severity level is A"))).to be true
      end
      it "student got the rating wrong (expected non-zero S), received feedback for incorrect rating" do
        @user = User.find_by_email("testuser@gmail.com")
        @quiz = Quiz.new({:user_id => @user.id, :which_grbas_letter => "S", :difficulty => 1, :num_questions => 1})
        @sound = Sound.find_by_id(6)
        @response = Response.create({:s_rating => 1, :reasoning => "yuh", :sound_id => @sound.id, :user_id => @user.id})
        @quiz.sounds << @sound
        @quiz.users << @user
        @quiz.responses << @response
        @quiz.save
        @response.save
        expect(@response.feedback).to eq(nil)
        @response.update(feedback: @response.create_feedback("s"))
        expect(@response.feedback.include?(("You recognized the tension or hyperfunction in this sample. The gold standard level was S"))).to be true
      end
    end
  end
end
