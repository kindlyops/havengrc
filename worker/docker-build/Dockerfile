FROM  havengrc-docker.jfrog.io/rocker/rstudio:3.4.3
LABEL maintainer="Kindly Ops, LLC <support@kindlyops.com>"

RUN apt-get update \
    && apt-get install -y zlib1g-dev libproj-dev texlive-full fonts-roboto texlive-fonts-extra xzdec gnupg \
    && tlmgr init-usertree
RUN tlmgr install roboto \
    && install2.r --deps=TRUE remotes \
    && install2.r --deps=TRUE tinytex \
    && install2.r --deps=TRUE formatR \
    && installGithub.r rstudio/rmarkdown \
    && installGithub.r kindlyops/tufte \
    && installGithub.r --deps=TRUE kindlyops/ggradar \
    && install2.r --deps=TRUE tint \
    && install2.r --deps=TRUE optparse \