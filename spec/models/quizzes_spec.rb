# frozen_string_literal: true

class QuizzesSpec
  describe Quiz do
    it "#translate_letter should give the right grbas characteristic for the letter" do
      grbas_letters = ["Grade", "Roughness", "Breathiness ", "Strain", "Asthenia", "Unknown letter"]
      grbas_letters.each do |characteristic|
        expect(Quiz.translate_letter(characteristic[0].downcase)).to eq(characteristic)
      end
    end
  end
end
