#!/bin/bash
set -eu
echo "steps:"
echo "queue: \"\$\$__QUEUE\""
# Testing multi-step generation for all *yaml in /opt/benchmark/driver-redpanda

# for testing, set BENCHMARK_ROOT in your env to your git location of 
#    https://github.com/redpanda-data/openmessaging-benchmark
_BENCHMARK_ROOT="${BENCHMARK_ROOT:-/opt/benchmark}"
_REDPANDA_DRIVER_ROOT="${_BENCHMARK_ROOT}/driver-redpanda"

# Loop through and exec all tests against cluster
find ${_REDPANDA_DRIVER_ROOT}/redpanda-*.yaml | while read -r t; do
  echo "  - command: \"sudo ${_BENCHMARK_ROOT}/bin/benchmark -d ${_BENCHMARK_ROOT}/$t ${_BENCHMARK_ROOT}/driver-redpanda/deploy/workloads/1-topic-100-partitions-1kb-4-producers-500k-rate.yaml\""
  echo "    label: \":rocket:\""
done

echo "  - command: \"sudo ${_BENCHMARK_ROOT}/bin/benchmark -d ${_BENCHMARK_ROOT}/$t ${_BENCHMARK_ROOT}/driver-redpanda/deploy/workloads/1-topic-100-partitions-1kb-4-producers-500k-rate.yaml\""
echo "    label: \":rocket:\""
echo "  - command: \"sudo cp -a /opt/benchmark/\""
echo "    label: \":rocket:\""
echo "  - command: \"python -m venv venv\""
echo "    label: \":python-black:\""
echo "  - command: \"source venv/bin/activate && python3 -m pip install numpy jinja2 pygal && cd /opt/benchmark && ./bin/generate_charts.py -h\""
echo "    label: \":python-black:\""

# A deploy step only if it's the master branch
# if [[ "$BUILDKITE_BRANCH" == "master" ]]; then
#   echo "  - wait"
#   echo "  - command: \"echo Deploy!\""
#   echo "    label: \":rocket:\""
# fi
