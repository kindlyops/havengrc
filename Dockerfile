FROM havengrc-docker.jfrog.io/kindlyops/sqitch:latest
ADD sqitch.conf sqitch.plan verify deploy revert /src/
