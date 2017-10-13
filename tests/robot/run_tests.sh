#!/bin/sh -e
python -m robot --outputdir ./logs/ \
                --variable MOCK_URL:${MOCK_URL} \
                ${ROBOT_ARGS} \
                --loglevel DEBUG \
                ./tests
