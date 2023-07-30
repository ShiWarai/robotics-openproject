FROM shiwarai/robotics-openproject-builds

SHELL ["/bin/bash", "-c"]
WORKDIR /robotics-openproject

RUN git clone https://github.com/ShiWarai/robotics-openproject.git --branch dev /robotics-openproject
RUN gem install --default bundler -v 2.4.17
RUN gem update --system
RUN cp config/database.yml.example config/database.yml
RUN cp config/configuration.yml.example config/configuration.yml

RUN bundle install >> log/setup.log

# Packages
#RUN apt-get update
#RUN apt-get install -y git curl build-essential zlib1g-dev libyaml-dev libssl-dev libpq-dev libreadline-dev

## Ruby
#RUN git clone https://github.com/rbenv/rbenv.git ~/.rbenv
#RUN cd ~/.rbenv && src/configure && make -C src
#RUN echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
#RUN eval "$(/root/.rbenv/bin/rbenv init - sh)"
#RUN ~/.rbenv/bin/rbenv init || :
#RUN echo 'eval "$(rbenv init - bash)"' >> ~/.bashrc
#RUN source ~/.bashrc
#RUN git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
#
## Node
#RUN git clone https://github.com/nodenv/nodenv.git ~/.nodenv
#RUN cd ~/.nodenv && src/configure && make -C src
#RUN echo 'export PATH="$HOME/.nodenv/bin:$PATH"' >> ~/.bashrc
#RUN ~/.nodenv/bin/nodenv init || :
#RUN echo 'eval "$(nodenv init -)"' >> ~/.bashrc
#RUN source ~/.bashrc
#RUN git clone https://github.com/nodenv/node-build.git ~/.nodenv/plugins/node-build
#
#RUN git clone https://github.com/ShiWarai/robotics-openproject.git --branch dev /robotics-openproject

ENTRYPOINT ["tail", "-f", "/dev/null"]

#RUN rbenv rehash
#RUN rbenv install 3.2.1
#RUN rbenv global 3.2.1
#RUN rbenv rehash
#
#RUN nodenv rehash
#RUN nodenv install 16.14.2
#RUN nodenv global 16.14.2
#RUN nodenv rehash
#RUN npm install npm@latest -g
