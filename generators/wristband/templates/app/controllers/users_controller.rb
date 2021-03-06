# -----------------------------------------------
# This file was generated by the acts_as_authenticated_user plugin
# Edit as needed ...
#
# More details at http://www.theworkinggroup.ca/rails/plugins/wristband
# -----------------------------------------------
class UsersController < ApplicationController
  
  # login_required is defined by the wristband plugin
  # if the user is not logged in it will call respond_not_logged_in
  before_filter :login_required
  
  
  def verify_email
    @user = User.verify_email!(params[:email_validation_key])
    flash[:notice] = 'Your email address has been verified. You may now login to your account.'
    redirect_to login_path
  rescue UserVerificationError => error
    flash[:error] = error.message
    redirect_to login_path
  end
  
  def forgot_password
    if request.post?
      if @user = User.find_by_username(params[:user][:username])
        @user.password = Wristband::Support.random_string(6)
        @user.save!
        UserNotifier::deliver_forgot_password(@user)
        flash[:notice] = 'A new password has been generated and emailed to the address you entered.'
        redirect_to login_path and return
      else
        @user = User.new
        @user.errors.add("email", "Cannot find that email address, did you mistype?")
      end
    end
  end
  
  
private
  # This will be called by the login_required filter when the user is not logged in
  # You can replace this with whatever you want.
  # You can also move this to Application controller so it can be shared with other controllers.
  def respond_not_logged_in
    redirect_to login_path
  end

end