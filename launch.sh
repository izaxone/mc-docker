#!/bin/bash

# Server Launch Script
# Created by izaxone (Discord nonme#0589)
# https://github.com/izaxone/mc-docker

# MIT License

# Copyright (c) 2022 izax.io

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# Check for server JAR
if [ -z $MC_SERVER_JAR ]
then
    echo "ERR: Missing setting: MC_SERVER_JAR. Please set these variables before starting the server."
    exit 1
fi

# Check Java Installation
if command -v java &> /dev/null
then
    # Build Java command
    JAVA_CMD="java"
    if [ ! -z $START_RAM ]
    then
        echo "Setting starting RAM"
        JAVA_CMD="$JAVA_CMD -Xms$START_RAM"
    fi
    if [ ! -z $MAX_RAM ]
    then
        echo "Setting max RAM"
        JAVA_CMD="$JAVA_CMD -Xmx$MAX_RAM"
    fi

    # If we're on Java 8 or lower, set the max threads.
    if [ $(($(java -version 2>&1 | sed -n ';s/.* version "\(.*\)\.\(.*\)\..*".*/\1\2/p;'))) -le 18 ] 
    then
            if [ -z $MAX_THREADS ]
            then
                echo "Missing setting: MAX_THREADS. Since you're using Java version 8 or lower it's recommended to set this for maximum performance."
            else
                export JAVA_CMD="$JAVA_CMD -XX:ParallelGCThreads=$MAX_THREADS"
                echo "Setting Max Threads $JAVA_CMD"
            fi
    fi
    JAVA_CMD="$JAVA_CMD -jar"
else
    echo "ERR: Java is not installed. Please install an appropriate Java Runtime Environment (JRE)"
fi

# Recommended Environment Variables for speed
REC_ENV_VARS=( "START_RAM" "MAX_RAM")
for i in "${REC_ENV_VARS[@]}"
do
    if [ -z $$i ]
    then
        echo "WARN: Missing setting: $i. It's recommended to set this for maximum performance."
    fi
done

if [ $MC_EULA != "true" ]
then
    echo "ERR: If you agree to the Minecraft EULA at https://www.minecraft.net/eula, please set MC_EULA to true in order to run the server. "
else
    echo "eula=true" > /opt/minecraft/eula.txt
fi

echo "Starting the server"

# Special pre-install steps. 
if [ ! -z $INSTALLED ]
then
    echo "Server already installed."
else
    echo "Installing the server"
    source /usr/local/bin/install.sh
fi

$JAVA_CMD "$MC_SERVER_JAR"

