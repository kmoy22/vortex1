#!/bin/bash

start_time=$SECONDS

TEST="--app=dot8 --args="-n256""
DEBUG="--debug=1"
# Debug 1 for lower verbosity, Debug 3 for highest verbosity

./ci/blackbox.sh --driver=simx --cores=4 --warps=4 --threads=4 $TEST | tee "simx_4w4t.log"
./ci/blackbox.sh --driver=simx --cores=4 --warps=4 --threads=8 $TEST | tee "simx_4w8t.log"
./ci/blackbox.sh --driver=simx --cores=4 --warps=8 --threads=4 $TEST | tee "simx_8w4t.log"
./ci/blackbox.sh --driver=simx --cores=4 --warps=8 --threads=8 $TEST | tee "simx_8w8t.log"

end_time=$SECONDS

elapsed_time=$((end_time - start_time))

echo "Shell script execution time: $elapsed_time seconds"