#! /bin/bash

chgrp backlight /sys/class/backlight/intel_backlight/brightness

chmod g+w /sys/class/backlight/intel_backlight/brightness