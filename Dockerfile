FROM fedora:27 AS aws-jars-provider
RUN curl -fLO https://jar-download.com/cache_jars/org.apache.hadoop/hadoop-aws/2.7.3/jar_files.zip \
    && yum install -y unzip && yum clean all \
    && unzip jar_files.zip \
    && rm jar_files.zip

FROM fedora:27 AS base
RUN yum install -y \
    hadoop-hdfs \
    && yum clean all

FROM base AS base-krb5
RUN yum install -y \
    krb5-workstation \
    krb5-libs \
    krb5-auth-dialog \
    && yum clean all

FROM base AS base-aws
COPY --from=aws-jars-provider *.jar /usr/share/hadoop/common/lib/

FROM base-krb5 AS base-aws-krb5
COPY --from=aws-jars-provider *.jar /usr/share/hadoop/common/lib/

FROM base AS onbuild
ONBUILD COPY ./conf/hadoop/*.xml /etc/hadoop/

FROM base-krb5 AS krb5-onbuild
ONBUILD COPY ./conf/krb5/krb5.conf /etc/krb5.conf

FROM base-aws AS aws-onbuild
ONBUILD COPY ./conf/hadoop/*.xml /etc/hadoop/

FROM base-aws-krb5 AS aws-krb5-onbuild
ONBUILD COPY ./conf/hadoop/*.xml /etc/hadoop/
ONBUILD COPY ./conf/krb5/krb5.conf /etc/krb5.conf
