FROM evserykh/rails:ruby2.6

RUN apt-get update && \
    apt-get install -y --no-install-recommends enca \
                                               libreoffice \
                                               libreoffice-l10n-ru \
                                               locales \
                                               locales-all \
                                               openjdk-8-jre-headless \
                                               uchardet \
                                               unzip

ENV LANG ru_RU.UTF-8
ENV LANGUAGE ru_RU:ru
ENV LC_ALL ru_RU.UTF-8

RUN set -eux; \
	apt-get update; \
	apt-get install -y gosu; \
# verify that the binary works
	gosu nobody true

COPY jodconverter-tomcat.tar.gz /opt
RUN cd /opt && \
    tar -xf jodconverter-tomcat.tar.gz && \
    rm jodconverter-tomcat.tar.gz

ARG max_size=104857600
RUN sed -i 's|<value>4194304</value><!-- 4MB -->|<value>104857600</value>|' \
      /opt/apache-tomcat-8.0.26/webapps/converter/WEB-INF/applicationContext.xml

RUN useradd -m -s /bin/bash ruby && mkdir /converter

COPY Gemfile Gemfile.lock /converter/
WORKDIR /converter
RUN bundle install
COPY . /converter
ENV RACK_ENV production

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]
EXPOSE 3000
EXPOSE 8080
CMD ["bundle", "exec", "rackup", "-o", "0.0.0.0", "-p", "3000"]
