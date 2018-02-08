FROM ruby:latest
ADD webapp /webapp


WORKDIR /webapp
RUN apt update -y && \
    apt install -y nodejs && \
    gem install bundle && \
    bundle install

CMD /webapp/bin/rails s -b 0.0.0.0
