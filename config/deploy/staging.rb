set :rails_env, "staging"
server "testbooru.donmai.us", :roles => %w(web app db), :primary => true, :user => "danbooru"
