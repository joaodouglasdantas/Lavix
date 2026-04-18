class CategoriesController < ApplicationController
  before_action :set_category, only: %i[show edit update destroy]

  def index
    @categories = current_user.categories.alphabetical
  end

  def show
    @recent_transactions = @category.transactions.recent.limit(20)
  end

  def new
    @category = current_user.categories.new(color: random_neon_friendly_color)
  end

  def edit
  end

  def create
    @category = current_user.categories.new(category_params)
    if @category.save
      redirect_to categories_path, notice: "Categoria criada com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @category.update(category_params)
      redirect_to categories_path, notice: "Categoria atualizada."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @category.destroy
      redirect_to categories_path, notice: "Categoria excluída.", status: :see_other
    else
      redirect_to categories_path, alert: @category.errors.full_messages.to_sentence, status: :see_other
    end
  end

  private

  def set_category
    @category = current_user.categories.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name, :color)
  end

  def random_neon_friendly_color
    %w[#FF6B00 #FF8F3C #E94560 #F9A826 #22D3EE #A78BFA #34D399 #F472B6].sample
  end
end
