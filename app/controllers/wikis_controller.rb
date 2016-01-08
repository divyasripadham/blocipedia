class WikisController < ApplicationController

  before_action :authenticate_user!, except: [:index, :show]

  def index
    @wikis = policy_scope(Wiki)
  end

  def show
    @wiki = Wiki.find(params[:id])
  end

  def new
    @wiki = Wiki.new
    @all_users = User.all
    @collaborators = @wiki.collaborators.build
  end

  def create
    @wiki = Wiki.new(wiki_params)
    @wiki.user = current_user

    params[:users][:id].each do |user|
      if !user.empty?
        @wiki.collaborators.build(:user_id => user)
      end
    end

    if @wiki.save
      redirect_to @wiki, notice: "Wiki was saved successfully."
    else
      flash[:error] = "Error creating wiki. Please try again."
      render :new
    end
  end

  def edit
    @wiki = Wiki.find(params[:id])
    @all_users = User.all
    @collaborators = @wiki.collaborators

    # We need to remove current user from the list

    # we need to iterate through the list and select all previous collaborators

  end

  def update
    @wiki = Wiki.find(params[:id])
    @wiki.assign_attributes(wiki_params)

    params[:users][:id].each do |user|
      if !user.empty?
        @wiki.collaborators.build(:user_id => user)
        flash[:notice] = "user."
      end
    end

    if @wiki.save
       flash[:notice] = "wiki was updated."
       redirect_to [@wiki]
    else
       flash[:error] = "There was an error saving the wiki. Please try again."
       render :edit
    end
  end

  def destroy
    @wiki = Wiki.find(params[:id])
    authorize @wiki
    if @wiki.destroy
      flash[:notice] = "\"#{@wiki.title}\" was deleted successfully."
      redirect_to wikis_path
    else
      flash[:error] = "There was an error deleting the wiki."
      render :show
    end
  end

  private
  def wiki_params
    params.require(:wiki).permit(:title, :body, :private)
  end

end
