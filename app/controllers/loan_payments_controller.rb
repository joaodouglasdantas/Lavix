class LoanPaymentsController < ApplicationController
  before_action :set_loan

  def create
    @payment = @loan.loan_payments.new(payment_params)
    if @payment.save
      @loan.sync_status!
      redirect_to @loan, notice: "Pagamento registrado."
    else
      @payments    = @loan.loan_payments.recent
      @new_payment = @payment
      render "loans/show", status: :unprocessable_entity
    end
  end

  def destroy
    @payment = @loan.loan_payments.find(params[:id])
    @payment.destroy
    @loan.sync_status!
    redirect_to @loan, notice: "Pagamento removido.", status: :see_other
  end

  private

  def set_loan
    @loan = current_user.loans.find(params[:loan_id])
  end

  def payment_params
    params.require(:loan_payment).permit(:amount, :paid_on, :installment_number, :notes)
  end
end
