FROM python:3.10-bookworm
LABEL description="Deploy Mage on ECS"
USER root

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

## System Packages
RUN \
  curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
  curl https://packages.microsoft.com/config/debian/11/prod.list > /etc/apt/sources.list.d/mssql-release.list && \
  apt-get -y update && \
  ACCEPT_EULA=Y apt-get -y install --no-install-recommends \
    # NFS dependencies
    nfs-common \
    # odbc dependencies
    msodbcsql18\
    unixodbc-dev \
    # R
    r-base && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*
RUN apt-get update && apt-get install -y libcairo2-dev libfribidi-dev libharfbuzz-dev libpng-dev libtiff-dev libv8-dev libssh2-1-dev cmake git-core libcurl4-openssl-dev libgit2-dev libicu-dev gfortran libssl-dev libxml2-dev  make pandoc zlib1g-dev libblas-dev liblapack-dev && rm -rf /var/lib/apt/lists/*
RUN apt-get -y update && apt-get install -y default-jdk r-cran-rjava && apt-get clean && rm -rf /var/lib/apt/lists/
## R Packages
RUN \
  R -e "install.packages('pacman', repos='http://cran.us.r-project.org')" && \
  R -e "install.packages('renv', repos='http://cran.us.r-project.org')" && \
  R -e 'install.packages(c("anomalize", "caret", "caTools", "changepoint", "dplyr", "janitor", "lubridate", "modeltime", "modeltime.ensemble", "modeltime.resample", "naniar", "prophet", "randomForest", "rsample", "timetk", "tsoutliers", "tune"))'

CMD ["python3"]