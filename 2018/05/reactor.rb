class Reactor

  def self.breakdown(polymer)
    polymer.downcase.chars.uniq.sort
  end

  def self.scrub(polymer, reagent)
    # strip out both polarities of the reagent from the polymer
    polymer.gsub(/#{reagent}/i, '')
  end

  def self.ignite(polymer)
    reacted = ''
    polymer.chars.each do |reagent|
      # ord give the ascii code for the characters
      # there are 32 code points between opposite reagents, so they annihilate each other
      # print "#{reacted[0..-25]} + #{reagent}"
      # print 13.chr
      if reacted.chars.last && (reacted.chars.last.ord - reagent.ord).abs == 32
        # the two reagents react
        reacted.chop!
      else
        reacted << reagent
      end
    end
    reacted
  end
end
