class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    # binding.pry
    ratings = if params.key?(:ratings)
                params[:ratings].keys
              elsif session.key?(:ratings)
                session[:ratings]
              else
                Movie.all_ratings
              end

    hash = {}
    ratings.each do |rating|
      hash[rating] = 1
    end

    order_by = if params.key?(:order_by)
                 params[:order_by]
               else
                 session[:order_by]
               end

    order_by = "" if order_by.nil?

    if !params.key?(:ratings) || !params.key?(:order_by)
      params[:ratings] = hash unless params.key?(:ratings)
      params[:order_by] = order_by unless params.key?(:order_by)
      flash.keep
      redirect_to movies_path(params)
    end

    @movies = Movie.with_ratings(ratings).order(order_by)
    @all_ratings = Movie.ratings(ratings)

    session[:order_by] = order_by
    session[:ratings] = ratings
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
