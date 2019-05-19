FROM evserykh/rails:ruby2.6

RUN apt-get update && \
    apt-get install -y --no-install-recommends enca \
                                               libreoffice \
                                               openjdk-8-jre-headless \
                                               uchardet \
                                               unzip

RUN set -eux; \
	apt-get update; \
	apt-get install -y gosu; \
# verify that the binary works
	gosu nobody true

COPY jodconverter-tomcat.tar.gz /opt
RUN cd /opt && \
    tar -xf jodconverter-tomcat.tar.gz && \
    rm jodconverter-tomcat.tar.gz

RUN useradd ruby && mkdir /converter

COPY Gemfile Gemfile.lock /converter/
WORKDIR /converter
RUN bundle install
COPY . /converter
ENV RACK_ENV production

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]
EXPOSE 3000
CMD ["bundle", "exec", "rackup", "-o", "0.0.0.0", "-p", "3000"]
