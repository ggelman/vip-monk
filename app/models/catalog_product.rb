class CatalogProduct < Sequel::Model
  one_to_many :items
  one_to_many :catalog_product_attributes
  one_to_many :reviews


  # def calculate_reviews_summary 
    # suma = @qty5 = @qty4 = @qty3 = @qty2 = @qty1 = 0;
    # for review in self.reviews do
      # eval("@qty" +review.points.to_i.to_s + "+=1")
      # suma+=review.points
    # end
    # @prom = ((suma * 2) / self.reviews.length).round / 2.to_f
  # end

  # def get_balls_image_link
    # return @prom.to_s.delete "."
  # end

  attr_reader :qty5, :qty4, :qty3, :qty2, :qty1, :prom

  def calculate_reviews_summary
    suma = @qty5 = @qty4 = @qty3 = @qty2 = @qty1 = 0;

    for review in self.reviews do
      eval("@qty" +review.points.to_i.to_s + "+=1")
      suma+=review.points
    end

    @prom = ((suma * 2) / self.reviews.length).round / 2.to_f
  end

  def get_balls_image_link
    if @prom.to_i != @prom.ceil
      return @prom.to_s.delete "."
    else
      return @prom.to_i
    end
  end

end
