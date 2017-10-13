FROM python:alpine3.6

RUN addgroup robot && adduser -D -G robot -h /home/robot robot

RUN apk update && apk add curl

WORKDIR /home/robot

ADD src ./src
ADD tests/robot/tests ./tests
ADD tests/robot/requirements.txt .
ADD tests/robot/run_tests.sh .
ADD resources/scripts/wait-for-url.sh .

RUN pip install -r requirements.txt

RUN chown -R robot:robot /home/robot

USER robot

ENTRYPOINT sh wait-for-url.sh ${MOCK_URL} ./run_tests.sh
