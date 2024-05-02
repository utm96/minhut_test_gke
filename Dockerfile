FROM python:3.10-bookworm

LABEL description="Deploy Mage on ECS"
USER root

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Combine all apt-get install commands into one RUN instruction to reduce the number of layers
RUN \
  curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
  curl https://packages.microsoft.com/config/debian/11/prod.list > /etc/apt/sources.list.d/mssql-release.list && \
  apt-get -y update && \
  ACCEPT_EULA=Y apt-get -y install --no-install-recommends \
    # NFS dependencies
    nfs-common \
    # odbc dependencies
    msodbcsql18 \
    unixodbc-dev \
    # R
    r-base \
    # Other dependencies
    libcairo2-dev libfribidi-dev libharfbuzz-dev libpng-dev libtiff-dev libv8-dev \
    libssh2-1-dev cmake git-core libcurl4-openssl-dev libgit2-dev libicu-dev \
    gfortran libssl-dev libxml2-dev make pandoc zlib1g-dev libblas-dev liblapack-dev \
    # Java and RJava
    default-jdk r-cran-rjava && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

# Create backup directory for R site-library
RUN mkdir -p /usr/local/lib/R/site-library-backup && \
    chown -R root:root /usr/local/lib/R/site-library-backup

# Install R packages
RUN R -e 'install.packages(c("remotes", "pacman"),lib="/usr/local/lib/R/site-library")'
# Install R packages using pacman
RUN R -e 'pacman::p_install(anomalize, caret, caTools, changepoint, dplyr, janitor, lubridate, modeltime, modeltime.resample, naniar, prophet, randomForest, rsample, timetk, tsoutliers, tune), lib="/usr/local/lib/R/site-library-backup")'

# Install modeltime.ensemble package using pacman
RUN R -e 'pacman::p_install_gh("business-science/modeltime.ensemble", lib="/usr/local/lib/R/site-library-backup")'

CMD ["bash"]
