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
    @movies = Movie.all
    
    sort = params[:sort]
    if sort == 'title'
      @movies = Movie.order('title')
      session[:sort] = sort
    end
    if sort == 'release_date'
      @movies = Movie.order('release_date')
      session[:sort] = sort
    end
    
    @all_ratings = Movie.all_ratings
    if params[:ratings] != nil && params[:sort] != nil
      if params[:ratings].present? && params[:sort].present?
        @selectRatings = params[:ratings].keys
        @movies = Movie.where(rating: @selectRatings)
        session[:ratings] = @selectRatings
        
        redirect_to movie_path(params[:sort][:ratings])
      elsif params[:ratings].present? && !params[:sort].present?
        @selectRatings = params[:ratings].keys
        @movies = Movie.where(rating: @selectRatings)
        session[:ratings] = @selectRatings
        
        redirect_to movie_path(params[:ratings])
      elsif !params[:ratings].present? && params[:sort].present?
        @selectRatings = params[:ratings].keys
        @movies = Movie.where(rating: @selectRatings)
        session[:ratings] = @selectRatings
        
        redirect_to movie_path(params[:sort])
      else
        flash.keep
      end
    end
    
    if params[:ratings].present?
      @selectRatings = params[:ratings].keys
      @movies = Movie.where(rating: @selectRatings)
    else
      @selectRatings = @all_ratings
    end
    
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
