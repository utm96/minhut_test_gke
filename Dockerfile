FROM mageai/mageai:latest
LABEL description="Deploy Mage on ECS"
USER root

RUN apt-get update && apt-get install -y libcairo2-dev libfribidi-dev libharfbuzz-dev libpng-dev libtiff-dev libv8-dev libssh2-1-dev cmake git-core libcurl4-openssl-dev libgit2-dev libicu-dev gfortran libssl-dev libxml2-dev  make pandoc zlib1g-dev libblas-dev liblapack-dev && rm -rf /var/lib/apt/lists/*
RUN apt-get -y update && apt-get install -y default-jdk r-cran-rjava && apt-get clean && rm -rf /var/lib/apt/lists/
## R Packages
RUN \
#   R -e 'install.packages(c("anomalize", "caret", "caTools", "changepoint", "dplyr", "janitor", "lubridate", "modeltime", "modeltime.ensemble", "modeltime.resample", "naniar", "prophet", "randomForest", "rsample", "timetk", "tsoutliers", "tune"))'
  R -e 'install.packages(c("dplyr"))'

WORKDIR /home/src
EXPOSE 6789
EXPOSE 7789
  
CMD ["/bin/sh", "-c", "/app/run_app.sh"]