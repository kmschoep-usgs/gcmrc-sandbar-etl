1. execute "copy *.txt sandbarfiles.txt" in folder where files reside
2. copy sandbarfiles.txt to fsshar1/etl/testing/sandbar/queue

log into igsarmfsshar1.er.usgs.gov via putty
navigate to mnt/data0/etl/testing/sandbar

3. on fsshar1: "scp -r queue cida-eros-jenkins-test.er.usgs.gov:/srv/etl/sandbar/queue"
4. run ETL with Ant Target = Default
5. Jenkins vm: "rm -rf queue"