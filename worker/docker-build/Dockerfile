FROM  havengrc-docker.jfrog.io/rocker/rstudio:3.4.3
LABEL maintainer="Kindly Ops, LLC <support@kindlyops.com>"

# RUN apt-get update \
#     && apt-get install -y zlib1g-dev libproj-dev texlive-full fonts-roboto texlive-fonts-extra xzdec gnupg \
#     && tlmgr init-usertree
# RUN tlmgr install roboto
RUN install2.r --deps=TRUE remotes
RUN install2.r --deps=TRUE tinytex
RUN install2.r --deps=TRUE formatR
RUN installGithub.r rstudio/rmarkdown
RUN installGithub.r kindlyops/tufte
RUN installGithub.r --deps=TRUE kindlyops/ggradar
RUN install2.r --deps=TRUE tint
RUN install2.r --deps=TRUE gridExtra
RUN install2.r --deps=TRUE ggthemes
RUN install2.r --deps=TRUE optparse
RUN install2.r --deps=TRUE reshape2
RUN install2.r --deps=TRUE cowplot
RUN install2.r --deps=TRUE likert

# overwrite embedded pandoc to be > 2.2 so that we have pptx output support
COPY vendor/pandoc-2.3.1/bin/pandoc /usr/local/bin/pandoc
COPY vendor/pandoc-2.3.1/bin/pandoc-citeproc /usr/local/bin/pandoc-citeproc