class ArticlesController < ApplicationController
    before_action :find_article, only: [:show,:edit,:update,:destroy]
    #before_action :authenticate_user!, only: [:new, :create:, :edit, :update, :destroy]
    before_action :authenticate_user!, :except => [:index, :show]

    def index
        @articles = Article.all
    end

    def new
        @article = Article.new
        @categories = Category.all
    end

    def create
        @article = current_user.articles.create(article_params)
        

        @article.save_categories
        redirect_to @article
    end

    def show

    end

    def edit
        @categories = Category.all

    end

    def update

        @article.update(article_params)
        @article.save_categories
        redirect_to @article
    end

    def destroy
        @has_category = HasCategory.where(article_id: params[:id])
        @has_category.delete_all     
        @article.destroy
        
        redirect_to root_path
        #Problema: se esta tratando de eliminar un articulo pero al ser una llave foranea de otra
        #tabla no me permite ya que en dicha el valor quedaria como nulo lo cual se permite.
        #Que haria: se tendria que acceder a la tabla has_category 
    end

    def from_author
        @user = User.find(params[:user_id])
    end

    def find_article
        @article = Article.find(params[:id])
    end

    def article_params
        params.require(:article).permit(:title,:content, category_elements: [])
    end


end
