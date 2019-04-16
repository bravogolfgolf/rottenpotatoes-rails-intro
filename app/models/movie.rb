class Movie < ActiveRecord::Base

  def self.all_ratings
    select('rating').distinct.map(&:rating).sort
  end

  def self.ratings(ratings)
    hash = {}
    arr = select('rating').distinct.map(&:rating).sort
    arr.each do |rating|
      hash[rating] = ratings.include? rating
    end
    hash
  end

  def self.with_ratings(ratings)
    where(rating: ratings)
  end
end
