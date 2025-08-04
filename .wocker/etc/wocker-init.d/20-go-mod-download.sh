#!/bin/sh

if [ -f "go.mod" ]; then
    go mod download
fi
