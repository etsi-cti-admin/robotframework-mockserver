*** Settings ***
Library  String
Library  RequestsLibrary
Library  ../src/MockServerLibrary/Keywords.py
Suite Setup  Create Sessions
Test Teardown  Reset Mock Server


*** Variables ***
${MOCK_URL}
${ENDPOINT}  /endpoint
&{BODY}  var1=value1  var2=value2
@{HEADERS}  Content-type: application/json  Cache-Control: max-age=3600
${MOCK_REQ}  {"method": "GET", "path": "${ENDPOINT}"}
${MOCK_RSP}  {"statusCode": 200}
${MOCK_TIMES}  {"remainingTimes": 1, "unlimited": true}
${MOCK_DATA}  {"httpRequest": ${MOCK_REQ}, "httpResponse": ${MOCK_RSP}, "times": ${MOCK_TIMES}}
${VERIFY_DATA}  {"httpRequest": ${MOCK_REQ}, "times": {"count": 1, "exact": true}}


*** Test Cases ***
Success On Expected GET
    &{req}=  Create Mock Request Matcher  GET  ${ENDPOINT}
    &{rsp}=  Create Mock Response  status_code=200
    Create Mock Expectation  ${req}  ${rsp}
    Send GET Expect Success  ${ENDPOINT}
    Verify Mock Expectation  ${req}

Success On Expected GET With Specified Data
    Create Mock Expectation With Data  ${MOCK_DATA}
    Send GET Expect Success  ${ENDPOINT}
    Verify Mock Expectation With Data  ${VERIFY_DATA}

Failure On Missing GET
    &{req}=  Create Mock Request Matcher  GET  ${ENDPOINT}
    &{rsp}=  Create Mock Response  status_code=200
    Create Mock Expectation  ${req}  ${rsp}
    Run Keyword And Expect Error  *  Verify Mock Expectation  ${req}

Failure On GET With Mismatched Endpoint
    &{req}=  Create Mock Request Matcher  GET  ${ENDPOINT}
    &{rsp}=  Create Mock Response  status_code=200
    Create Mock Expectation  ${req}  ${rsp}
    Send GET Expect Success  endpoint=${ENDPOINT}
    ${mismatched}=  Set Variable  /mismatch
    &{req_mis}=  Create Mock Request Matcher  GET  ${mismatched}
    Run Keyword And Expect Error  *  Verify Mock Expectation  ${req_mis}

Success On Expected GET With Response Body
    &{req}=  Create Mock Request Matcher  GET  ${ENDPOINT}
    &{rsp}=  Create Mock Response  status_code=200  headers=${HEADERS}  body=${BODY}
    Create Mock Expectation  ${req}  ${rsp}
    Send GET Expect Success  ${ENDPOINT}  response_headers=${HEADERS}  response_body=${BODY}
    Verify Mock Expectation  ${req}

Success On Two Expected GETs
    &{req}=  Create Mock Request Matcher  GET  ${ENDPOINT}
    &{rsp}=  Create Mock Response  status_code=200
    Create Mock Expectation  ${req}  ${rsp}  count=2
    Repeat Keyword  2  Send GET Expect Success  ${ENDPOINT}
    Verify Mock Expectation  ${req}  count=2

Failure On Too Many GETs
    &{req}=  Create Mock Request Matcher  GET  ${ENDPOINT}
    &{rsp}=  Create Mock Response  status_code=200
    Create Mock Expectation  ${req}  ${rsp}
    Repeat Keyword  2  Send GET Expect Success  ${ENDPOINT}
    Run Keyword And Expect Error  *  Verify Mock Expectation  ${req}  count=1

Success On Unspecified Number Of GETs
    &{req}=  Create Mock Request Matcher  GET  ${ENDPOINT}
    &{rsp}=  Create Mock Response  status_code=200
    Create Mock Expectation  ${req}  ${rsp}
    Repeat Keyword  3  Send GET Expect Success  ${ENDPOINT}
    Verify Mock Expectation  ${req}  exact=${false}

Success On Expected POST With Body
    [Tags]  smoke
    &{req}=  Create Mock Request Matcher  POST  ${ENDPOINT}  body=${BODY}
    &{rsp}=  Create Mock Response  status_code=200
    Create Mock Expectation  ${req}  ${rsp}
    Send POST Expect Success  ${ENDPOINT}  ${BODY}
    Verify Mock Expectation  ${req}

Failure On POST With Mismatched Body
    &{req}=  Create Mock Request Matcher  POST  ${ENDPOINT}  body=${BODY}
    &{rsp}=  Create Mock Response  status_code=200
    Create Mock Expectation  ${req}  ${rsp}
    Send POST Expect Success  ${ENDPOINT}  ${BODY}
    &{mismatched}=  Create Dictionary  var1=mismatch  var2=value2
    &{req_mis}=  Create Mock Request Matcher  POST  ${ENDPOINT}  body=${mismatched}
    Run Keyword And Expect Error  *  Verify Mock Expectation  ${req_mis}

Success On Request Sequence
    &{req1}=  Create Mock Request Matcher  GET  /endpoint1
    &{req2}=  Create Mock Request Matcher  POST  /endpoint2
    &{req3}=  Create Mock Request Matcher  GET  /endpoint3
    &{rsp}=  Create Mock Response  status_code=200

    Create Mock Expectation  ${req1}  ${rsp}
    Create Mock Expectation  ${req2}  ${rsp}
    Create Mock Expectation  ${req3}  ${rsp}

    Send GET Expect Success  /endpoint1
    Send POST Expect Success  /endpoint2
    Send GET Expect Success  /endpoint3

    @{seq}=  Create List  ${req1}  ${req2}  ${req3}
    Verify Mock Sequence  ${seq}

Failure On Partial Request Sequence
    &{req1}=  Create Mock Request Matcher  GET  /endpoint1
    &{req2}=  Create Mock Request Matcher  POST  /endpoint2
    &{req3}=  Create Mock Request Matcher  GET  /endpoint3
    &{rsp}=  Create Mock Response  status_code=200

    Create Mock Expectation  ${req1}  ${rsp}
    Create Mock Expectation  ${req2}  ${rsp}
    Create Mock Expectation  ${req3}  ${rsp}

    Send GET Expect Success  /endpoint1
    Send POST Expect Success  /endpoint2

    @{seq}=  Create List  ${req1}  ${req2}  ${req3}
    Run Keyword And Expect Error  *  Verify Mock Sequence  ${seq}

Failure On Misordered Request Sequence
    &{req1}=  Create Mock Request Matcher  GET  /endpoint1
    &{req2}=  Create Mock Request Matcher  POST  /endpoint2
    &{req3}=  Create Mock Request Matcher  GET  /endpoint3
    &{rsp}=  Create Mock Response  status_code=200

    Create Mock Expectation  ${req1}  ${rsp}
    Create Mock Expectation  ${req2}  ${rsp}
    Create Mock Expectation  ${req3}  ${rsp}

    Send POST Expect Success  /endpoint2
    Send GET Expect Success  /endpoint1
    Send GET Expect Success  /endpoint3

    @{seq}=  Create List  ${req1}  ${req2}  ${req3}
    Run Keyword And Expect Error  *  Verify Mock Sequence  ${seq}

Success On Default GET Expectation
    Create Default Mock Expectation  GET  ${ENDPOINT}
    Send GET Expect Success  ${ENDPOINT}

Success On Default POST Expectation
    Create Default Mock Expectation  POST  ${ENDPOINT}
    Send POST Expect Success  ${ENDPOINT}

Success On Default POST Create Expectation
    Create Default Mock Expectation  POST  ${ENDPOINT}  response_code=201
    Send POST Expect Success  ${ENDPOINT}  response_code=201

Success On Default GET Expectation With Response Body
    Create Default Mock Expectation  GET  ${ENDPOINT}  response_headers=${HEADERS}  response_body=${BODY}
    Send GET Expect Success  ${ENDPOINT}  response_headers=${HEADERS}  response_body=${BODY}

Success On Retrieve Requests
    Create Default Mock Expectation  GET  ${ENDPOINT}
    Create Default Mock Expectation  GET  /endpoint2
    Send GET Expect Success  ${ENDPOINT}
    Send GET Expect Success  /endpoint2
    ${rsp}=  Retrieve Requests  ${ENDPOINT}
    Log  ${rsp.text}  DEBUG
    ${rsp_str}=  Convert To String  ${rsp.text}
    Should Contain  ${rsp_str}  GET
    Should Contain  ${rsp_str}  ${ENDPOINT}
    Should Not Contain  ${rsp_str}  /endpoint2

Success On Clear Requests
    Create Default Mock Expectation  GET  ${ENDPOINT}
    Send GET Expect Success  ${ENDPOINT}
    Clear Requests  ${ENDPOINT}
    ${rsp}=  Retrieve Requests  ${ENDPOINT}
    Log  ${rsp.text}  DEBUG
    ${rsp_str}=  Convert To String  ${rsp.text}
    Should Not Contain  ${rsp_str}  GET
    Should Not Contain  ${rsp_str}  ${ENDPOINT}

Success On Retrieve Expectations
    Create Default Mock Expectation  GET  ${ENDPOINT}
    ${rsp}=  Retrieve Expectations  ${ENDPOINT}
    Log  ${rsp.text}  DEBUG
    ${rsp_str}=  Convert To String  ${rsp.text}
    Should Contain  ${rsp_str}  GET
    Should Contain  ${rsp_str}  ${ENDPOINT}

*** Keywords ***
Create Sessions
    Create Session  server  ${MOCK_URL}
    Create Mock Session  ${MOCK_URL}

Reset Mock Server
    Dump To Log
    Reset All Requests

Send GET Expect Success
    [Arguments]  ${endpoint}=${ENDPOINT}  ${response_headers}=${None}  ${response_body}=${None}
    ${rsp}=  Get Request  server  ${endpoint}
    Should Be Equal As Strings  ${rsp.status_code}  200
    Run Keyword If   ${response_headers != None}  Verify Response Headers  ${response_headers}  ${rsp.headers}
    Run Keyword If   ${response_body != None}  Verify Response Body  ${response_body}  ${rsp.text}

Send POST Expect Success
    [Arguments]  ${endpoint}=${ENDPOINT}  ${body}=${BODY}  ${response_code}=200
    ${body_json}=  Evaluate  json.dumps(${body})  json
    ${rsp}=  Post Request  server  ${endpoint}  data=${body_json}
    Should Be Equal As Strings  ${rsp.status_code}  ${response_code}

Verify Response Headers
    [Arguments]  ${expected}  ${actual}
    :FOR  ${header}  IN  @{expected}
    \  ${actual_str}=  Convert To String  ${actual}
    \  Should Contain  ${actual_str.replace("'", "")}  ${header}

Verify Response Body
    [Arguments]  ${expected}  ${actual}
    ${exp_json}=  Evaluate  json.dumps(${expected})  json
    Should Be Equal As Strings  ${exp_json}  ${actual}
