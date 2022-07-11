class MembersOnlyArticlesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  before_action :check_if_member

  def index
    articles = Article.where(is_member_only: true).includes(:user).order(created_at: :desc)
    render json: articles, each_serializer: ArticleListSerializer
  end

  def show
    article = Article.find(params[:id])
    render json: article
  end



  private

  def record_not_found
    render json: { error: "Article not found" }, status: :not_found
  end

  def check_if_member
    unless session[:user_id]
      render json: { error: "Not authorized"}, status: 401
    end
  end

end
