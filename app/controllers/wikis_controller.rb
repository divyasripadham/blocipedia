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
    # @collaborators = @wiki.collaborators.build
    # Made this change for the form_for in form.html. The 'if' check for the first select list.
    @collaborators = Collaborator.none
  end

  def create
    # raise
    @wiki = Wiki.new(wiki_params)
    @wiki.user = current_user

    params[:users][:id].each do |user|
      if !user.empty?
        @wiki.collaborators.build(:user_id => user)
      end
    end

    if @wiki.user.standard?
      @wiki.private = false
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
  end

  def update
    # raise
    @wiki = Wiki.find(params[:id])
    @wiki.assign_attributes(wiki_params)

    if params[:users] && params[:users][:id]
      params[:users][:id].each do |user|
        if user.present?
          @wiki.collaborators.build(:user_id => user)
          flash[:notice] = "user."
        end
      end
    end

    if params[:collabs] && params[:collabs][:id]
      params[:collabs][:id].reject {|id| id.empty?}.each do |collab_id|
        collab = Collaborator.find(collab_id)
        flash[:notice] = "#{collab.username} was deleted"
        collab.delete
      end
    end

    if @wiki.user.standard?
      @wiki.private = false
    end

    if !@wiki.private
      @wiki.collaborators.clear
    end

    if @wiki.save
       flash[:notice] = "wiki was updateddsfdfs."
       redirect_to [@wiki]
    else
       flash[:error] = "There was an error saving the wiki. Please try again."
       render :edit
    end
  end

  def destroy
    @redirect_path = wiki_path
    @wiki = Wiki.find(params[:id])
    authorize @wiki
    if @wiki.destroy
      flash[:notice] = "\"#{@wiki.title}\" was deleted successfully."
      redirect_to wikis_path
    else
      flash[:error] = "There was an error deleting the wiki."
      redirect_to @redirect_path
    end
  end

  private
  def wiki_params
    params.require(:wiki).permit(:title, :body, :private)
  end

end
