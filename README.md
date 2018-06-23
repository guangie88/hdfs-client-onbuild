# `hdfs-client-onbuild`

Dockerfile set-up containing `hdfs` command for interaction with HDFS server.
The image is based on `fedora:27`.

`kinit`/`klist` commands are available for `:krb5-onbuild` tagged image.

`s3a://` protocol for HDFS is available for `:aws-onbuild` tagged image. Use
`aws-krb5-onbuild` to get both the above features.

`ONBUILD COPY` are performed for setting up `hdfs` and `krb5`. See below for
more information.

## Hadoop Configuration

Place all the modified XML configurations (e.g. `core-site.xml`) for Hadoop in
`./conf/hadoop/`. Note that the `.` refers to the directory of your own
`Dockerfile`. Unmodified XML files need not appear in the directory, but at
least one XML file must be present due to the limitation of `COPY` command.

## Kerberos Configuration

Place the modified `krb5.conf` for Kerberos in `./conf/krb5/krb5.conf`. Note
that the `.` refers to the directory of your own `Dockerfile`. This file must be
present for the `ONBUILD COPY` to work.
