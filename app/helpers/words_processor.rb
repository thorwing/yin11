require 'rubygems'
require 'rmmseg'

class WordsProcessor
  def self.process(content)
    #initialize the Dictionary for word segmentation
    RMMSeg::Dictionary.add_dictionary("#{Rails.root}/lib/include/silver_hornet/dictionaries/silver.dic", :words)
    RMMSeg::Dictionary.load_dictionaries

    @dic_words = []
    File.open(File.join(Rails.root, 'lib/include/silver_hornet/dictionaries/silver.dic')).each_line do |line|
      word = line.split(" ")[1]
      @dic_words << word unless @dic_words.include?(word)
    end

    seg_words(content)
  end

  def self.seg_words(content)
      words = []
      algor = RMMSeg::Algorithm.new(content)
      loop do
        tok = algor.next_token
        break if tok.nil?

        words.push(tok.text.force_encoding("UTF-8")) if @dic_words.include?(tok.text.force_encoding("UTF-8")) && !words.include?(tok.text.force_encoding("UTF-8"))
      end

      words
    end
end