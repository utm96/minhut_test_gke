FROM python:3.10-bookworm

LABEL description="Deploy lib container on dockerhub"
USER root

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Combine all apt-get install commands into one RUN instruction to reduce the number of layers
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    curl https://packages.microsoft.com/config/debian/11/prod.list > /etc/apt/sources.list.d/mssql-release.list && \
    apt-get -y update && \
    ACCEPT_EULA=Y apt-get -y install --no-install-recommends \
    nfs-common \
    msodbcsql18 \
    unixodbc-dev \
    r-base \
    libcairo2-dev libfribidi-dev libharfbuzz-dev libpng-dev libtiff-dev libv8-dev \
    libssh2-1-dev cmake git-core libcurl4-openssl-dev libgit2-dev libicu-dev \
    gfortran libssl-dev libxml2-dev make pandoc zlib1g-dev libblas-dev liblapack-dev \
    default-jdk r-cran-rjava && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


# Install R packages
RUN R -e 'install.packages(c("diagram", "loo", "rstan", "BH", "dials", "lubridate", "rstantools", "DBI", "diffobj", "magrittr", "rstudioapi", "DiceDesign", "digest", "markdown", "rvest", "Formula", "distributional", "matrixStats", "salesforcer", "GPfit", "doFuture", "memoise", "sass", "ModelMetrics", "doParallel", "mime", "scales", "PerformanceAnalytics", "dplyr", "miniUI", "selectr", "Quandl", "dtplyr", "modeldata", "semantic.assets", "QuickJSR", "dygraphs", "modelenv", "shape", "R.methodsS3", "e1071", "modelr", "shiny", "R.oo", "earth", "modeltime", "shiny.semantic", "R.utils", "ellipsis", "modeltime.ensemble", "shinyWidgets", "R6", "evaluate", "modeltime.resample", "shinyalert", "RColorBrewer", "extraDistr", "munsell", "shinybusy", "RSQLite", "fansi", "naniar", "shinyjs", "Rcpp", "farver", "norm", "slider", "RcppArmadillo", "fastmap", "numDeriv", "snakecase", "RcppEigen", "flexdashboard", "openssl", "sourcetools", "RcppParallel", "fontawesome", "pROC", "stringi", "RcppRoll", "forcats", "pacman", "stringr", "SQUAREM", "foreach", "padr", "sweep", "SaldaeReporting", "forecast", "parallelly", "sys", "StanHeaders", "fracdiff", "parsnip", "systemfonts", "TTR", "fs", "patchwork", "tensorA", "UpSetR", "furrr", "phosphoricons", "testthat", "V8", "future", "pillar", "textshaping", "XML", "future.apply", "pins", "th2forecast", "abind", "gargle", "pkgbuild", "th2ml", "alphavantager", "generics", "pkgconfig", "tibble", "anomalize", "ggplot2", "pkgload", "tibbletime", "anytime", "git2r", "plogr", "tictoc", "askpass", "glmnet", "plotly", "tidymodels", "assertr", "globals", "plotmo", "tidyquant", "assertthat", "glue", "plotrix", "tidyr", "attempt", "golem", "plyr", "tidyselect", "backports", "googledrive", "posterior", "tidyverse", "base64enc", "googlesheets4", "praise", "timeDate", "bigD", "gower", "prettyunits", "timechange", "bit", "gridExtra", "processx", "timetk", "bit64", "gt", "prodlim", "tinytex", "bitops", "gtable", "progress", "toastui", "blob", "hardhat", "progressr", "tseries", "brio", "haven", "promises", "tsoutliers", "broom", "heddlr", "prophet", "tune", "bslib", "here", "proxy", "tzdb", "caTools", "highr", "ps", "urca", "cachem", "hms", "purrr", "utf8", "callr", "htmltools", "quadprog", "uuid", "caret", "htmlwidgets", "quantmod", "vctrs", "cellranger", "httpuv", "ragg", "viridis", "changepoint", "httr", "randomForest", "viridisLite", "checkmate", "ids", "rappdirs", "visdat", "classInt", "infer", "reactR", "vroom", "cli", "inline", "reactable", "waldo", "clipr", "ipred", "readr", "warp", "clock", "isoband", "readxl", "whisker", "colorspace", "iterators", "recipes", "withr", "colourpicker", "janitor", "rematch", "workflows", "commonmark", "jquerylib", "rematch2", "workflowsets", "config", "jsonlite", "renv", "writexl", "conflicted", "juicyjuice", "reprex", "xfun", "cpp11", "knitr", "reshape2", "xgboost", "crayon", "labeling", "riingo", "xml2", "crosstalk", "later", "rio", "xtable", "curl", "lava", "rlang", "xts", "data.table", "lazyeval", "rlist", "yaml", "data.validator", "lhs", "rmarkdown", "yardstick", "datamods", "lifecycle", "rprojroot", "zip", "dbplyr", "listenv", "rsample", "zoo"))' && \
    R -e 'pacman::p_install_gh("business-science/modeltime.ensemble")'

CMD ["bash"]
