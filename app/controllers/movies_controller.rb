class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index

    if session[:ratings].nil?
      @movies = Movie.find(:all)
    end
    
    selected_ratings = session[:ratings] || param[:ratings]
    @all_ratings = ['G','PG','PG-13','R']

    sort = params[:sort] || session[:sort]
    case sort
      when 'title'
      @movies = Movie.order('title')
      when 'release_date'
      @movies = Movie.order('release_date')
    end 

    @movies = Movie.where('rating in (?)', params[:ratings].keys) if params["ratings"]

    session[:sort] = sort
    if selected_ratings != {}
      session[:ratings] = selected_ratings
    end
  end


  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
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
