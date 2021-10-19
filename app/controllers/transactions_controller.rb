class TransactionsController < ApplicationController
  def student_transactions
    @transactions = Transaction.where(user_id: current_user.id).order('updated_at DESC')
  end
end
