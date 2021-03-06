FROM centos:centos6
MAINTAINER Alex Leonhardt

RUN yum -y install epel-release
RUN yum -y install python-pip python-devel make gcc supervisor
RUN yum -y update

RUN mkdir -p /opt/sensu-grid

ADD templates /opt/sensu-grid/templates
ADD static /opt/sensu-grid/static
ADD conf /opt/sensu-grid/conf
ADD requirements.txt /opt/sensu-grid/requirements.txt
ADD *.py /opt/sensu-grid/
ADD docker-start.sh /opt/sensu-grid/docker-start.sh

RUN pip install -r /opt/sensu-grid/requirements.txt
RUN useradd -r sensu-grid
RUN chown -R sensu-grid:sensu-grid /opt/sensu-grid
RUN chmod 640 /opt/sensu-grid/conf/config.yaml && chmod 755 /opt/sensu-grid/docker-start.sh
RUN touch /var/log/sensu-grid.log && chown sensu-grid:sensu-grid /var/log/sensu-grid.log

ADD start-scripts/supervisord-docker.conf /etc/supervisord.conf

WORKDIR /opt/sensu-grid

EXPOSE 5000

ENTRYPOINT ["/opt/sensu-grid/docker-start.sh"]
