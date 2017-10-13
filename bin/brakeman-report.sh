#!/bin/bash

brakeman --no-exit-on-warn --no-exit-on-error -f html > tmp/brakeman-report.html
