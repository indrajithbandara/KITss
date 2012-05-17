class AdminAreaController < ApplicationController
  before_filter :admin_user?
  
  private

    def admin_user?
      redirect_to(root_path) unless current_user and current_user.admin?
    end
end
