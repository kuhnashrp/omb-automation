#!/bin/bash

set -eu

echo "steps:"

# Testing multi-step generation for all *yaml in /opt/benchmark/driver-redpanda

_BENCHMARK_ROOT="${BENCHMARK_ROOT:-/opt/benchmark}"
find ${_BENCHMARK_ROOT}/driver-redpanda/redpanda-*.yaml | while read -r t; do
  echo "  - command: \"sudo ${_BENCHMARK_ROOT}/bin/benchmark -d ${_BENCHMARK_ROOT}/$t ${_BENCHMARK_ROOT}/driver-redpanda/deploy/workloads/1-topic-100-partitions-1kb-4-producers-500k-rate.yaml\""
  echo "    label: \":rocket:\""
done

# A deploy step only if it's the master branch
# if [[ "$BUILDKITE_BRANCH" == "master" ]]; then
#   echo "  - wait"
#   echo "  - command: \"echo Deploy!\""
#   echo "    label: \":rocket:\""
# fi
