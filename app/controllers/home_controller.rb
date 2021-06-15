class HomeController < ApplicationController
  skip_before_action :require_login

  def index
  end

  def faq
  end

end
