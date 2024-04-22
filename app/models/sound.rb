class Sound < ActiveRecord::Base
  has_many :responses
  has_and_belongs_to_many :quizzes, join_table: "quiz_sounds"

  def self.get_sound(grbas_letter, difficulty)
    str = grbas_letter + "_rating"
    Sound.where("#{str} = ?", difficulty).sample
  end

  def self.get_sound2(grbas_letter1, grbas_letter2, difficulty)
    str = (grbas_letter1 + "_rating").to_sym
    str2 = (grbas_letter2 + "_rating").to_sym
    Sound.where({ str => difficulty }).where({ str2 => difficulty }).sample

  end

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

  def self.get_anchor(which_grbas_letter)
    Sound.find_by_db_file_name("anchor_#{which_grbas_letter}").audio_file_path
  end
end
