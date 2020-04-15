
# Base image
FROM ubuntu:16.04
MAINTAINER Paul Murrell <paul@stat.auckland.ac.nz>

# add CRAN PPA
RUN apt-get update && apt-get install -y apt-transport-https
RUN echo 'deb https://cloud.r-project.org/bin/linux/ubuntu xenial-cran35/' > /etc/apt/sources.list.d/cran.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9

# Install additional software
# R stuff
RUN apt-get update && apt-get install -y \
    xsltproc \
    r-base=3.6* \ 
    libxml2-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    bibtex2html \
    subversion 

# For building the report
RUN Rscript -e 'install.packages(c("knitr", "devtools"), repos="https://cran.rstudio.com/")'
RUN Rscript -e 'library(devtools); install_version("xml2", "1.2.2", repos="https://cran.rstudio.com/")'

# Tools used in the report
RUN apt-get update && apt-get install -y \
    texlive-full \
    fonttools \
    fontconfig \
    libxml2-utils

# Packages used in the report
RUN Rscript -e 'library(devtools); install_version("gridGraphics", "0.5-0", repos="https://cran.rstudio.com/")'
RUN Rscript -e 'library(devtools); install_version("gdata", "2.18.0", repos="https://cran.rstudio.com/")'

# Package dependencies
# 'xml2' already installed
RUN Rscript -e 'library(devtools); install_version("extrafont", "0.17", repos="https://cran.rstudio.com/")'
RUN Rscript -e 'extrafont::font_import(prompt=FALSE)'
RUN Rscript -e 'library(devtools); install_version("hexView", "0.3-4", repos="https://cran.rstudio.com/")'
RUN apt-get install -y libfontconfig1-dev
RUN Rscript -e 'library(devtools); install_github("thomasp85/systemfonts")'

# Using COPY will update (invalidate cache) if the tar ball has been modified!
# COPY dvir_0.2-0.tar.gz /tmp/
# RUN R CMD INSTALL /tmp/dvir_0.2-0.tar.gz
RUN Rscript -e 'devtools::install_github("pmur002/dvir@v0.2-0")'

RUN apt-get install -y locales && locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8

ENV TERM dumb

# Create $HOME and directory in there for FontConfig files
RUN mkdir -p /home/user/fontconfig/conf.d
ENV HOME /home/user
