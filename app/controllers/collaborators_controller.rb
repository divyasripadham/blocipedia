class CollaboratorsController < ApplicationController

  def index
    @wiki = Wiki.find(params[:wiki_id])
  end

  def create
  end

  def destroy
  end

end
