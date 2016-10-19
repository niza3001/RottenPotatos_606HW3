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
      
      if params[:ratings].nil?     #if the user has not set any rating
          if session[:ratings].nil?   #and the session history is also empty
              session[:ratings] = {}
          @all_ratings.each do |r|
              session[:ratings][r] = 1  #check all ratings
        end
          end
        else
        session[:ratings] = params[:ratings]
      end
      
      if params[:sort_by].nil?
        if session[:sort_by].nil?
            session[:sort_by] = "id" #if no other option is chosen arrange by id
        end
        else
        session[:sort_by] = params[:sort_by]
        end
      #if the user has not chosen a setting yet, use session
      if params[:ratings].nil? || params[:sort_by].nil?
      redirect_to movies_url(sort_by: session[:sort_by], ratings: session[:ratings])
      
      end
      @movies = Movie.where(rating: session[:ratings].keys)
      
    if params[:sort_by].to_s == 'title' #if sorting by title
          @sort_by_title = 'hilite' #make titles yellow
          @movies = @movies.order(params[:sort_by]) #sort by title
    elsif params[:sort_by].to_s == 'release_date' #same as above for release  date
          @sort_by_release_date = 'hilite'
          @movies = @movies.order(params[:sort_by])
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
