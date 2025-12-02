FROM evserykh/rails:ruby2.6

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -

RUN sed -i 's|http://deb.debian.org/debian|http://archive.debian.org/debian|g' /etc/apt/sources.list && \
    sed -i 's|http://security.debian.org/debian-security|http://archive.debian.org/debian-security|g' /etc/apt/sources.list && \
    sed -i '/stretch-updates/d' /etc/apt/sources.list

RUN apt-get update --allow-releaseinfo-change -o Acquire::Check-Valid-Until=false && \
    apt-get install -y --no-install-recommends \
                       libasound2 \
                       libasound2-data \
                       libxtst6 \
                       enca \
                       libfile-mimeinfo-perl \
                       libreoffice \
                       libreoffice-l10n-ru \
                       locales \
                       locales-all \
                       uchardet \
                       unzip

COPY vendor/bellsoft-jre8u382+6-linux-amd64.deb java.deb
RUN dpkg -i java.deb && rm java.deb

ENV LANG=ru_RU.UTF-8
ENV LANGUAGE=ru_RU:ru
ENV LC_ALL=ru_RU.UTF-8

RUN set -eux; \
	apt-get update; \
	apt-get install -y gosu; \
# verify that the binary works
	gosu nobody true

COPY vendor/jodconverter-tomcat.tar.gz /opt
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
ENV RACK_ENV=production

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]
EXPOSE 3000
EXPOSE 8080
CMD ["bundle", "exec", "rackup", "-o", "0.0.0.0", "-p", "3000"]
