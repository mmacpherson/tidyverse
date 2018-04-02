FROM rocker/tidyverse
LABEL maintainer="Mike Macpherson <mmacpherson@users.noreply.github.com>"


RUN mkdir -p $HOME/.R

# $HOME doesn't exist in the COPY shell, so be explicit
COPY R/Makevars /root/.R/Makevars

# -- Docker Hub (and Docker in general) chokes on memory issues when compiling
#    with gcc, so copy custom CXX settings to /root/.R/Makevars and use ccache
#    and clang++ instead
# -- Install ed, since nloptr needs it to compile.
RUN apt-get update && apt-get install --no-install-recommends -y \
    ccache \
    clang  \
    ed \
    libhdf5-dev \
&& rm -rf /var/lib/apt/lists/*


RUN install2.r --error \
    PRROC \
    ROCR \
    boot \
    brms \
    doMC \
    glmnet \
    glmnetUtils \
    hdf5r \
    interplot \
    lme4 \
    mice \
    pROC \
    reticulate \
    rstan \
&& rm -rf /tmp/downloaded_packages/ /tmp/*.rds


# -- TODO
#    ----
#    1. Install multidplyr for parallel tidyverse magic
#    2. caret \ ## FAILS, looks like you need to install dependencies explicitly?


# -- Thanks to Andrew Heiss for the template on which this is based.
#    https://github.com/andrewheiss/tidyverse-rstanarm

