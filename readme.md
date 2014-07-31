copy approx 500 files at a time to fsshar1/etl/testing/sandbar/queue

log into igsarmfsshar1.er.usgs.gov via putty
navigate to mnt/data0/etl/testing/sandbar

1. on fsshar1: "scp -r queue cida-eros-jenkins-test.er.usgs.gov:/srv/etl/sandbar/queue"
2. run ETL with Ant Target = areaVolCalcFileUpload
3. Jenkins vm: "rm -rf queue"

Copy next 500 files, repeat steps 1-3 until all files loaded.

4. run ETL with Ant Target = transformData