class Sound < ActiveRecord::Base
  # allows responses to track which sound is associated to a particular response
  has_many :responses
  # allows quizzes to track and load which songs are associated to a particular quiz
  has_and_belongs_to_many :quizzes, join_table: "quiz_sounds"

  # Function: get_sound takes in a GRBAS letter and a scale "0-3" number to randomly select a sound
  # this does also exclude the anchor samples
  # Return type: Sound
  def self.get_sound(grbas_letter, difficulty)
    str = grbas_letter + "_rating"
    anchor_sounds = ["anchor_a", "anchor_b", "anchor_r", "anchor_s"]
    Sound.where({ str.to_sym => difficulty }).where.not({:db_file_name => anchor_sounds}).sample
  end

  #Function: same as get_sound but with 2 GRBAS letter so that it selects the same scale
  # number for 2 letters ie G,R,0 is provided, the get_sound will locate all sounds in database
  # that have G0 R0 and randomly return one to the users
  #Functionality for increasing test complexity, excluded due to limit in sounds
  # def self.get_sound2(grbas_letter1, grbas_letter2, difficulty)
  #   str = (grbas_letter1 + "_rating").to_sym
  #   str2 = (grbas_letter2 + "_rating").to_sym
  #   Sound.where({ str => difficulty }).where({ str2 => difficulty }).sample
  # end

  # Function: search takes a sound_id, letter, and rating to find the list of sounds associated to the search parameters given
  # I.E. if sound_id is given then it will find the sound associated to that id, otherwise
  # it checks rating and sound such that for any letter / scale number combo, it will return all the sounds
  # that contain that combination. For example, if G and 0 is given to the function, it locates all sounds in the database
  # with a G0 rating.
  # Return type: Array of Sounds
  def self.search(sound_id, letter, rating)
    search_ids = !(sound_id.nil? || sound_id.empty?)
    search_rating = !(rating.nil? || rating.empty?) && !(letter.nil? || letter.empty?)
    sounds = []
    if search_ids
      sounds = Sound.where("id = ?", Sound.sanitize_sql_like(sound_id))
    end
    if search_rating
      sounds = sounds.empty? ?
                 Sound.where("#{letter}_rating = ?", Sound.sanitize_sql_like(rating)) :
                 sounds.where("#{letter}_rating = ?", Sound.sanitize_sql_like(rating))
    end
    return sounds
  end

  # Function: find_score of the sound based on the GRBAS letter associated
  # Return type: double value for the scale level associated to that sound and letter
  def find_score (grbas_letter)
    case grbas_letter
    when "g"
      self.g_rating
    when "r"
      self.r_rating
    when "b"
      self.b_rating
    when "a"
      self.a_rating
    when "s"
      self.s_rating
    else
      nil
    end
  end

  # Function: get_anchor retrieves the anchor sample associated to the letter given
  # to the function. For example, given the letter R, function returns sound
  # associated to db_file_name: anchor_r.
  # Return type: Sound
  def self.get_anchor(which_grbas_letter)
    Sound.find_by_db_file_name("anchor_#{which_grbas_letter}").audio_file_path
  end
end
