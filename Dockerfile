FROM kindlyops/sqitch:latest
ADD sqitch.conf sqitch.plan verify deploy revert /src/
