class ReviewsController < ApplicationController
  before_filter :authorize

  def create
    @product = Product.find(params[:product_id])
    @review = Review.new(review_params)

    @review.user = current_user
    @review.product_id = @product.id

    if @review.save
      redirect_to product_path(@product)
    else
      render :'products/show'
    end

  end

  def destroy
    @product = Product.find(params[:product_id])
    @review = Review.find params[:id]

    if @review.user == current_user
      @review.destroy
      redirect_to product_path(@product), notice: 'Product deleted!'
    else
      render :'products/show'
    end

  end

  private

    def review_params
      params.require(:review).permit(:description, :rating)
    end
end
