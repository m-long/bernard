module ApplicationHelper

  # Returns the full title on a per-page basis
  def full_title(page_title="")
    base_title="Bernard.ai"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end

  # Confirms a logged in user
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Please log in to access this page."
      redirect_to login_url
    end
  end

  # Confirms an admin user
  def admin_user
    redirect_to root_url unless current_user.admin?
  end
end
