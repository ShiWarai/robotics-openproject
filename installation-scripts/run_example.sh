sudo apt-get install -y git curl build-essential zlib1g-dev libyaml-dev libssl-dev libpq-dev libreadline-dev
sudo apt-get install -y zlib1g-dev build-essential           \
                    libssl-dev libreadline-dev                      \
                    libyaml-dev libgdbm-dev                         \
                    libncurses5-dev automake                        \
                    libtool bison libffi-dev git curl               \
                    poppler-utils unrtf tesseract-ocr catdoc        \
                    libxml2 libxml2-dev libxslt1-dev
sudo apt-get install -y postgresql postgresql-contrib libpq-dev postgresql-client


# Postgres
sudo pg_ctlcluster 12 main start
sudo su postgres
createuser -d -P openproject
# psql # ALTER USER openproject CREATEDB;
alter role openproject superuser;
create database openproject;
# openproject
sudo service postgresql restart


# Ruby
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
cd ~/.rbenv && src/configure && make -C src
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
~/.rbenv/bin/rbenv init
echo 'eval "$(rbenv init - bash)"' >> ~/.bashrc
source ~/.bashrc
cd ~

git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
rbenv install 3.2.1
rbenv global 3.2.1
rbenv rehash

# Install nodenv
git clone https://github.com/nodenv/nodenv.git ~/.nodenv
cd ~/.nodenv && src/configure && make -C src
echo 'export PATH="$HOME/.nodenv/bin:$PATH"' >> ~/.bashrc
~/.nodenv/bin/nodenv init
echo 'eval "$(nodenv init -)"' >> ~/.bashrc
source ~/.bashrc
cd ~
git clone https://github.com/nodenv/node-build.git $(nodenv root)/plugins/node-build

nodenv install 16.14.2
nodenv global 16.14.2
nodenv rehash

npm install npm@latest -g

git clone https://github.com/ShiWarai/robotics-openproject.git --branch dev
cd robotics-openproject
gem update --system
gem install --default bundler -v 2.4.16
cp config/database.yml.example config/database.yml
cp config/configuration.yml.example config/configuration.yml

bundle install >> log/setup.log

bundle exec rake db:migrate RAILS_ENV=production SECRET_KEY_BASE=e7fc3c2c8bec7b789b1ddbac5425c680055aadd3a3015e93f58fd5914dfebbaef30249414ea5813db5df619ebab246e96cf5b4f38d58b42452de85f5af6cf242
bundle exec rake db:seed RAILS_ENV=production OPENPROJECT_DEFAULT_LANGUAGE=ru SECRET_KEY_BASE=e7fc3c2c8bec7b789b1ddbac5425c680055aadd3a3015e93f58fd5914dfebbaef30249414ea5813db5df619ebab246e96cf5b4f38d58b42452de85f5af6cf242

rm -rf public/assets >> log/setup.log
(cd frontend && npm ci) >> log/setup.log
bundle exec rake openproject:plugins:register_frontend >> log/setup.log
bundle exec rake assets:precompile RAILS_ENV=production SECRET_KEY_BASE=e7fc3c2c8bec7b789b1ddbac5425c680055aadd3a3015e93f58fd5914dfebbaef30249414ea5813db5df619ebab246e96cf5b4f38d58b42452de85f5af6cf242

# back
RAILS_ENV=production SECRET_KEY_BASE=e7fc3c2c8bec7b789b1ddbac5425c680055aadd3a3015e93f58fd5914dfebbaef30249414ea5813db5df619ebab246e96cf5b4f38d58b42452de85f5af6cf242 RAILS_SERVE_STATIC_FILES=true OPENPROJECT_HTTPS=false bundle exec rails server
# front
RAILS_ENV=production SECRET_KEY_BASE=e7fc3c2c8bec7b789b1ddbac5425c680055aadd3a3015e93f58fd5914dfebbaef30249414ea5813db5df619ebab246e96cf5b4f38d58b42452de85f5af6cf242 npm run serve
# email
RAILS_ENV=production SECRET_KEY_BASE=e7fc3c2c8bec7b789b1ddbac5425c680055aadd3a3015e93f58fd5914dfebbaef30249414ea5813db5df619ebab246e96cf5b4f38d58b42452de85f5af6cf242 bundle exec rails jobs:work
