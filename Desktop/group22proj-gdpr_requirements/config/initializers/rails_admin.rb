RailsAdmin.config do |config|

  config.authorize_with do
    redirect_to '/home' unless current_user.admin?
  end

  config.actions do
    dashboard                     # mandatory
    # live_chat                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end
end
