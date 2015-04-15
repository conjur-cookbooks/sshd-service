#!/bin/bash

conjur env run -- knife cookbook site share sshd-service "Other" -o ../. -VV
