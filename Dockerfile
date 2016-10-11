#Grab the latest alpine image
FROM registry.heroku.com/demo-mssql
ENV SECRET="https://private-repo.microsoft.com/u/config-6823a30c-64e1-4464-9e99-41239213b795.tar.gz"
ENV ACCEPT_EULA="Y"
ENV MSSQL_SERVER_SA_PASSWORD="Salesforce1"

ENV BUILD_PKGS wget

RUN yum -y install $BUILD_PKGS && \
    yum -y update && \
    curl https://private-repo.microsoft.com/tools/configure-mssql-repo-2.sh | sh /dev/stdin $SECRET && \
    yum install -y mssql-server && \
    echo -e "YES\n$MSSQL_SERVER_SA_PASSWORD\n$MSSQL_SERVER_SA_PASSWORD" | /opt/mssql/bin/sqlservr-setup; \
    yum -y remove $BUILD_PKGS && \
    yum -y clean all

#EXPOSE 1433
#VOLUME /var/opt/mssql

#USER mssql
ENTRYPOINT ["/bin/sh", "-c", "/opt/mssql/bin/sqlservr"]
CMD docker run -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=Salesforce1" -p $PORT:1433 -d registry.heroku.com/demo-mssql 