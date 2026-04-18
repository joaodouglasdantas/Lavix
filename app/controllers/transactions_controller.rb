class TransactionsController < ApplicationController
  before_action :set_transaction, only: %i[show edit update destroy]

  def index
    @transactions = current_user.transactions
                                .includes(:category)
                                .recent

    @transactions = @transactions.where(kind: params[:kind]) if Transaction::KINDS.include?(params[:kind])
    @transactions = @transactions.where(category_id: params[:category_id]) if params[:category_id].present?
  end

  def show
  end

  def new
    @transaction = current_user.transactions.new(date: Date.current, kind: "expense")
    ensure_has_categories!
  end

  def edit
    ensure_has_categories!
  end

  def create
    @transaction = current_user.transactions.new(transaction_params)
    if @transaction.save
      redirect_to transactions_path, notice: "Lançamento registrado."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @transaction.update(transaction_params)
      redirect_to transactions_path, notice: "Lançamento atualizado."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @transaction.destroy
    redirect_to transactions_path, notice: "Lançamento removido.", status: :see_other
  end

  private

  def set_transaction
    @transaction = current_user.transactions.find(params[:id])
  end

  def transaction_params
    params.require(:transaction).permit(:amount, :kind, :description, :date, :category_id)
  end

  def ensure_has_categories!
    return if current_user.categories.exists?

    redirect_to new_category_path, alert: "Crie pelo menos uma categoria antes de lançar."
  end
end
