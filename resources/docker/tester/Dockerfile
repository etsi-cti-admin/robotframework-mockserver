FROM python:alpine3.6

RUN addgroup robot && adduser -D -G robot -h /home/robot robot

RUN apk update && apk add curl

WORKDIR /home/robot

COPY src ./src
COPY resources/scripts/setup.py .
COPY tests/robot/tests .
COPY tests/robot/requirements.txt .
COPY tests/robot/run_tests.sh .
COPY resources/scripts/wait-for-url.sh .

## Build development distribution
RUN python setup.py sdist

RUN pip install -r requirements.txt

RUN chown -R robot:robot /home/robot

USER robot

ENTRYPOINT sh wait-for-url.sh ${MOCK_URL} ./run_tests.sh
