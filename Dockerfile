FROM ubuntu:18.04
MAINTAINER Altanai Bisht <tara181989@gmail.com>
ENV build_date 2021-01-20

WORKDIR /tmp
RUN apt-get update && \
    apt-get install -y build-essential git-core pkg-config subversion libjansson-dev sqlite autoconf \
      automake libtool libxml2-dev libncurses5-dev unixodbc unixodbc-dev libasound2-dev libogg-dev \
      libvorbis-dev libneon27-dev libspandsp-dev uuid uuid-dev sqlite3 libsqlite3-dev \
      libedit* wget && \

    wget https://downloads.asterisk.org/pub/telephony/asterisk/asterisk-18.9.0.tar.gz && \
    tar -xzf asterisk-18.9.0.tar.gz && \
    rm asterisk-18.9.0.tar.gz && \
    cd asterisk-* && \
    ./configure --with-pjproject-bundled && \
    contrib/scripts/get_mp3_source.sh && \
    make menuselect.makeopts && \
    menuselect/menuselect \

      # required for asterisk to work ok in docker (check http://stackoverflow.com/a/19610145/920295)
      --disable BUILD_NATIVE \

      # MENUSELECT_ADDONS category
      --disable chan_mobile \
      --enable format_mp3 \
      --disable res_config_mysql \
      --disable app_mysql \
      --disable cdr_mysql \

      # MENUSELECT_APPS category
      --disable app_db \

      menuselect.makeopts && \
    make && \
    make install && \

    # The conf files will be populated by the init.sh script
    # make samples && \

    cd /tmp && \
    rm -rf asterisk-* && \
    sed -i -e 's/# MAXFILES=/MAXFILES=/' /usr/sbin/safe_asterisk && \

    # uninstall wget so that it's not in the image
    apt-get remove -y wget && \
    rm -rf /var/lib/apt/lists/*

COPY extensions.conf http.conf pjsip.conf confbridge.conf /tmp/

VOLUME ["/etc/asterisk", "/var/spool/asterisk", "/var/log/asterisk"]

CMD ["/bin/bash", "asterisk -f"]
