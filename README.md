# docker_build_auto
This script for helps to make a docker image with verification automatically 

* You can type this command at the parent directory of Dockerfile directory as below

```
$] ls 
centos-baseimage docker_build_auto docker_cli_dashboard gadge gravity-bakery zinst zinst_privates


$] docker_build_auto.sh
=====================================
1 | centos-baseimage
2 | docker_build_auto
3 | docker_cli_dashboard
4 | gadge
5 | gravity-bakery
6 | zinst
7 | zinst_privates
=====================================
Please insert a number for build:

```

* You have to make a Dockerfile for build an image before this command

* You can see as below messages with "verified" tag if everything is okay.
```
 === Port EXPOSE check===
99357b0a1613        centos6_zinst_httpd:latest   "tailf /etc/resolv.c   1 seconds ago       Up Less than a second   80/tcp              centos6_zinst_httpd   
 Stopping the Temporary container.....
centos6_zinst_httpd
centos6_zinst_httpd
=====================================
 Running new container for tagging new....
=====================================
 Good job!  everything is okay!
verified/centos6_zinst_httpd                       latest              686416c72f52        13 days ago         630.2 MB
=====================================

```


[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/goody80/docker_build_auto/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

