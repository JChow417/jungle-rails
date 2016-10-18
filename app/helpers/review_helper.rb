module ReviewHelper

  def star_or_stars(rating)
    rating == 1 ? 'Star' : 'Stars'
  end

end
