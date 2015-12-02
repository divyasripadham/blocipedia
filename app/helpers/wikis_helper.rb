module WikisHelper
  def private_topic?(wiki)
    (wiki.private == false) ? 'Public' : 'Private'
  end
  def user_authorized_to_edit_wikis?
    current_user
  end
end
