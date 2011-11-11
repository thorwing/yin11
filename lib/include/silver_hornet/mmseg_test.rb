require 'rubygems'
require 'rmmseg'

RMMSeg::Dictionary.add_dictionary("#{Rails.root}//lib//include//silver_dictionaries//", :words)
RMMSeg::Dictionary.load_dictionaries

  algor = RMMSeg::Algorithm.new("who am i, i am a person")
  loop do
    tok = algor.next_token
    break if tok.nil?
    puts "#{tok.text} [#{tok.start}..#{tok.end}]"
  end