#!/bin/bash

swayidle -w \
    timeout 300 'swaylock -f' \
    timeout 600 'wlopm --off *' \
    resume 'wlopm --on *' \
    before-sleep 'swaylock -f'
