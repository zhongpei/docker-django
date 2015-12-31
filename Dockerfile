FROM ubuntu:14.04
MAINTAINER Zhong Pei <zhongpei@vip.qq.com>

# keep upstart quiet
RUN dpkg-divert --local --rename --add /sbin/initctl
RUN ln -sf /bin/true /sbin/initctl

# no tty
ENV DEBIAN_FRONTEND noninteractive

ADD ./requirements.dev.txt /opt/requirements.txt
# RUN sed -i 's/archive.ubuntu.com/mirrors.163.com/' /etc/apt/sources.list 
RUN	 apt-get update --fix-missing \
	&& apt-get install -y build-essential git \
	&& apt-get install -y python python-dev python-setuptools python-pip python-virtualenv  \
	&& apt-get install -y --no-install-recommends libjpeg-dev libfreetype6-dev  zlib1g-dev libpng12-dev python-imaging  libmysqlclient-dev \
	&& apt-get build-dep -y python-imaging python-psycopg2 \
	&& pip install -r /opt/requirements.txt   -i  http://pypi.douban.com/simple/ \
	&& pip install supervisor-stdout  -i  http://pypi.douban.com/simple/\
	&& apt-get install -y supervisor\
	&& apt-get remove -y python-dev build-essential libjpeg-dev libfreetype6-dev  zlib1g-dev libpng12-dev \
	&& rm -fr ~/.cache/pip \
	&& apt-get -y clean && apt-get -y autoclean

# stop supervisor service as we'll run it manually
RUN service supervisor stop

# start supervisor to run our wsgi server
ADD ./supervisord.conf /etc/supervisord.conf
CMD supervisord -c /etc/supervisord.conf -n

# expose port(s)
EXPOSE 5000
