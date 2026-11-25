#!/usr/bin/env bash

cd "$(dirname "$0")/.." || exit 2

echo "=================================="
echo "SECURITY CONTROL COVERAGE"
echo "=================================="

awk -F, '
NR > 1 {
    total++
    if ($2 == "true") {
        enabled++
        print "[OK] " $1
    } else if ($2 == "false") {
        missing++
        print "[WARNING] Build scanning missing: " $1
    } else {
        invalid++
        print "[ERROR] Unknown status: " $1
    }
}
END {
    print ""
    print "Repositories:", total
    print "Build scanning enabled:", enabled+0
    print "Build scanning missing:", missing+0
    if (total > 0)
        printf "Control coverage: %.0f%%\n", enabled/total*100
    if (invalid > 0 || total == 0)
        exit 2
    if (missing > 0)
        exit 1
}' lab/repository-inventory.csv
