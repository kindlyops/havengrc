# Haven GRC Security Culture Survey Results

This zip file contains your Security Culture Survey results as well as the
source data for generating the graph so you can remix/reuse/share to your
hearts content.

## Presentation with your results

*filename*: SecurityCultureSurveyPresentation.pptx
*Description*: This presentation is compatible with PowerPoint and Keynote. 
It contains your survey results graph as well some explainations of each quadrant.

### Source files

Also included: your survey response data and the source code for the graph.

- `docker-compose.yml`
- `presentation.Rmd`
- `template.pptx`
- `havengrc-surveyresults.csv`

To compile the report, you can open the presentation.Rmd notebook in 
[RStudio](https://www.rstudio.com/). Since many developers have a
[Docker](https://www.docker.com/products/docker-desktop) environment already set
up, we have also provided a docker-compose file with an R environment already configured.

### Usage

    docker-compose run report

## Credit

The [Security Culture Diagnostic Survey (SCDS)](http://lancehayden.net/culture/#stacks_out_83_page1)
by [Lance Hayden, Ph.D.](http://lancehayden.net/) and generously provided under a 
[Creative Commons Attribution-ShareAlike 4.0 International License](http://creativecommons.org/licenses/by-sa/4.0/)

[Haven GRC](https:///www.havengrc.com) is created by [Kindly Ops](https://kindlyops.com)
code is available  at [GitHub](https://github.com/kindlyops/havengrc)
