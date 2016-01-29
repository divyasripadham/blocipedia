class CollaboratorsController < ApplicationController

  def index
    # @wiki = Wiki.find(params[:wiki_id])
  end

  def manage
    # raise
    # search for user and show search screen
    # Display all collaborators
    @wiki = Wiki.find(params[:wiki_id])
    @collaborators = @wiki.collaborators
    if params[:search].present?
      search_string = params[:search]
      puts "params value search string 1 #{search_string}"
      @users = User.where("email LIKE ? and id <> ?", "%#{params[:search]}%",current_user.id)
      # @users.count
      puts "params value search string 2 #{search_string}"
    end
  end

  def create
    # create collaborator and go to search screen
    puts "Inside Create"
  end

  def destroy
    # delete collaborator and go to search screen
  end

end
