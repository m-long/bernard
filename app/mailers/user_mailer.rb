class UserMailer < ApplicationMailer

  def account_activation(user)
    @user = user
    mail to: user.email, subject: "Account activation for mattlong.la"
  end

  def password_reset(user)
    @user = user
    mail to: user.email, subject: "Password reset for mattlong.la"
  end
end
