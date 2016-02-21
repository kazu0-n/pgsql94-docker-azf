FROM centos:latest
MAINTAINER hostmaster@std-adhocracy.net
ENV container docker

RUN yum -y update; yum clean all
RUN yum -y install sudo epel-release samba-client samba-common cifs-utils ; yum clean all

# Setting Azure Storage Mount
#RUN touch /etc/sysconfig/azfile_env
ADD ./azfenv.sh /usr/local/sbin/azfenv.sh
RUN chmod +x /usr/local/sbin/azfenv.sh
ADD ./azfenv.service /etc/systemd/system/azfenv.service
ADD ./mnt-pgsql.mount /etc/systemd/system/mnt-pgsql.mount

# Postgres PITR Setting
ADD ./pgsql_pitr.timer /etc/systemd/system/pgsql_pitr.timer
ADD ./pgsql_pitr.service /etc/systemd/system/pgsql_pitr.service
ADD ./pgsql_pitr.sh /usr/local/sbin/pgsql_pitr.sh
RUN chmod +x /usr/local/sbin/pgsql_pitr.sh

# Install systemd
#RUN yum swap -y fakesystemd systemd || true

# Setting pgsql94 repositris
RUN rpm -ivh http://yum.postgresql.org/9.4/redhat/rhel-7-x86_64/pgdg-centos94-9.4-2.noarch.rpm

# Install pgsql94 and necessary rpms
RUN yum -y install postgresql94-server postgresql94 postgresql94-contrib ; yum clean all

# Setting Postgresql Unit
ADD ./postgresql-9.4.service /etc/systemd/postgresql-9.4.service

#set up initdb
RUN su - postgres -c "/usr/pgsql-9.4/bin/initdb --encoding=UTF8 --no-locale --pgdata=/var/lib/pgsql/9.4/data --auth=ident"

#Sudo requires a tty. fix that.
RUN sed -i 's/.*requiretty$/#Defaults requiretty/' /etc/sudoers

#Setup postgres env
ADD ./postgres_env.sh /usr/local/sbin/postgres_env.sh
RUN touch /etc/sysconfig/postgres_env
#RUN chown -v postgres.postgres /etc/sysconfig/postgres_env
RUN chmod +x /usr/local/sbin/postgres_env.sh

#Setup create databese
ADD ./createdb.service /etc/systemd/system/createdb.service
ADD ./create_db.sh /usr/local/sbin/create_db.sh
ADD ./stop_createdb.sh /usr/local/sbin/stop_createdb.sh
RUN chmod +x /usr/local/sbin/create_db.sh
#RUN chmod +x /etc/systemd/system/createdb.service
RUN chmod +x /usr/local/sbin/stop_createdb.sh

#Setup postgresql.conf
ADD ./postgresql.conf /var/lib/pgsql/9.4/data/postgresql.conf
RUN chown -v postgres.postgres /var/lib/pgsql/9.4/data/postgresql.conf

#Setup pg_hba.conf
ADD ./pg_hba.conf /var/lib/pgsql/9.4/data/pg_hba.conf
RUN chown -v postgres.postgres /var/lib/pgsql/9.4/data/pg_hba.conf

# Expose port 5432 and set  pgsql94  our entrypoint
EXPOSE 5432
RUN systemctl enable postgresql-9.4
RUN systemctl enable createdb.service
RUN systemctl enable azfenv.service
RUN systemctl enable mnt-pgsql.mount
RUN systemctl enable pgsql_pitr.timer
CMD ["/sbin/init"]