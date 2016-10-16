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
      @all_ratings = Movie.all_ratings
      ratings = params[:ratings] ? (params[:ratings].keys) : @all_ratings
      @movies_rated = Movie.where(rating: ratings)
      
    if params[:sort_by].to_s == 'title' #if sorting by title
          @sort_by_title = 'hilite' #make titles yellow
          @movies = @movies_rated.order(params[:sort_by]) #sort by title
    elsif params[:sort_by].to_s == 'release_date' #same as above for release  date
          @sort_by_release_date = 'hilite'
          @movies = @movies_rated.order(params[:sort_by])
    else
        @movies = @movies_rated
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
