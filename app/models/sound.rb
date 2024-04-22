class Sound < ActiveRecord::Base
  has_many :responses
  has_and_belongs_to_many :quizzes, join_table: "quiz_sounds"

  def self.get_sound(grbas_letter, difficulty)
    str = grbas_letter + "_rating"
    Sound.where("#{str} = ?", difficulty).sample
  end

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
end
