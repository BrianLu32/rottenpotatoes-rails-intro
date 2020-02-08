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
    #@movies = Movie.all
    
    @all_ratings = Movie.all_ratings
    @selectRatings = @all_ratings
    if params[:ratings] != nil || params[:sort] != nil
      
      if params[:ratings].present? && params[:sort].present?
        sort = params[:sort]
        @selectRatings = params[:ratings].keys
        @movies = Movie.where(rating: @selectRatings).order(sort)
        session[:ratings] = @selectRatings
        session[:sort] = sort
        if sort == 'title'
          @color = 'hilite'
        elsif sort == 'release_date'
          @color2 = 'hilite'
        end
        
      elsif params[:ratings].present? && !params[:sort].present?
        if session[:sort] == nil
          @selectRatings = params[:ratings].keys
          @movies = Movie.where(rating: @selectRatings)
          session[:ratings] = @selectRatings
        elsif session[:sort] != nil
          sort = session[:sort]
          @selectRatings = params[:ratings].keys
          @movies = Movie.where(rating: @selectRatings).order(sort)
          session[:ratings] = @selectRatings
          session[:sort] = sort
          if sort == 'title'
            @color = 'hilite'
          elsif sort == 'release_date'
            @color2 = 'hilite'
          end
        end
        
      elsif !params[:ratings].present? && params[:sort].present?
        sort = params[:sort]
        if session[:ratings] == nil
          @movies = Movie.order(sort)
          session[:sort] = sort
        elsif session[:ratings] != nil
          @selectRatings = session[:ratings]
          @movies = Movie.where(rating: @selectRatings).order(sort)
          session[:ratings] = @selectRatings
          session[:sort] = sort
          if sort == 'title'
            @color = 'hilite'
          elsif sort == 'release_date'
            @color2 = 'hilite'
          end
        end
      
      elsif !params[:ratings].present? && !params[:sort].present?
        if session[:ratings] != nil && session[:sort] != nil
          sort = session[:sort]
          @selectRatings = session[:ratings]
          @movies = Movie.where(rating: @selectRatings).order(sort)
          session[:ratings] = @selectRatings
          session[:sort] = sort
          if sort == 'title'
            @color = 'hilite'
          elsif sort == 'release_date'
            @color2 = 'hilite'
          end
          
        elsif session[:ratings] != nil && session[:sort] == nil
          @selectRatings = session[:ratings]
          @movies = Movie.where(rating: @selectRatings)
          session[:ratings] = @selectRatings
          
        elsif session[:ratings] == nil && session[:sort] != nil
          sort = session[:sort]
          @movies = Movie.order(sort)
          session[:sort] = sort
          if sort == 'title'
            @color = 'hilite'
          elsif sort == 'release_date'
            @color2 = 'hilite'
          end
          
        elsif session[:ratings] == nil && session[:sort] == nil
          @movies = Movie.all
        end
        
      else
        flash.keep
      end
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
