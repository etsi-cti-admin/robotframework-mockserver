import requests
import json
from urllib.parse import urljoin
from collections import namedtuple
from robot.api import logger

from .version import VERSION

__version__ = VERSION


class MockServerLibrary(object):

    ROBOT_LIBRARY_SCOPE = 'GLOBAL'
    ROBOT_LIBRARY_VERSION = __version__

    def create_mock_session(self, base_url):
        """Create an HTTP session towards the mock server"""
        self.base_url = base_url
        self.session = requests.Session()

    def create_mock_request_matcher(self, method, path, body_type='JSON', body=None, exact=True):
        """Create a mock response to be used by the mock server"""
        req = {}
        req['method'] = method
        req['path'] = path

        if body_type is 'JSON' and body:
            match_type = 'STRICT' if exact else 'ONLY_MATCHING_FIELDS'
            req['body'] = {'type': body_type, 'json': json.dumps(body), 'matchType': match_type}

        return req

    def create_mock_response(self, status_code, headers=None, body_type='JSON', body=None):
        """Create a mock response to be used by the mock server"""
        rsp = {}
        rsp['statusCode'] = int(status_code)

        if headers:
            rsp['headers'] = []

            for key, value in headers.items():
                header = {'name': key, 'values': value.split(",")}
                rsp['headers'].append(header)
                logger.debug("Add header - header: {}".format(header))

        if body_type is 'JSON' and body:
            rsp['body'] = json.dumps(body)

        return rsp

    def create_mock_expectation(self, request, response, count=1, unlimited=True):
        """Create an expectation to be used by the mock server"""
        data = {}
        data['httpRequest'] = request
        data['httpResponse'] = response
        data['times'] = {'remainingTimes': int(count), 'unlimited': unlimited}

        self.create_mock_expectation_with_data(data)

    def create_default_mock_expectation(self, method, path, response_code=200,
                                        response_headers=None, body_type='JSON',
                                        response_body=None):
        """Create a default expectation to be used by the mock server"""
        req = self.create_mock_request_matcher(method, path, exact=False)
        rsp = self.create_mock_response(response_code, response_headers, body_type, response_body)
        self.create_mock_expectation(req, rsp, unlimited=True)

    def create_mock_expectation_with_data(self, data):
        """Create an expectation with defined data to be used by the mock server"""
        self._send_request("/expectation", data)

    def verify_mock_expectation(self, request, count=1, exact=True):
        """Verify that the mock server has received a specific request n times"""
        data = {}
        data['httpRequest'] = request
        data['times'] = {'count': int(count), 'exact': exact}

        self.verify_mock_expectation_with_data(data)

    def verify_mock_expectation_with_data(self, data):
        """Verify a mock expectation with specified data"""
        self._send_request("/verify", data)

    def verify_mock_sequence(self, requests):
        """Verify that the mock server has received a specific request sequence"""
        body = {}
        body["httpRequests"] = requests
        data = json.dumps(body)
        self._send_request("/verifySequence", data)

    def retrieve_requests(self, path):
        """Retrieve all received request from the mock server"""
        body = {}
        body['path'] = path
        data = json.dumps(body)
        return self._send_request("/retrieve", data)

    def retrieve_expectations(self, path):
        """Retrieve all expectations from the mock server"""
        body = {}
        body['path'] = path
        data = json.dumps(body)
        return self._send_request("/retrieve?type=expectation", data)

    def clear_requests(self, path):
        """Clear requests matching a specific expectation from the mock server"""
        body = {}
        body['path'] = path
        data = json.dumps(body)
        self._send_request("/clear", data)

    def reset_all_requests(self):
        """Clear all received requests from the mock server"""
        self._send_request("/reset")

    def dump_to_log(self):
        """Dump mock server logs"""
        self._send_request("/dumpToLog")

    def _send_request(self, path, data=None):
        if isinstance(data, dict):
            data_dump = json.dumps(data)
        else:
            data_dump = data

        url = urljoin(self.base_url, path)

        logger.debug("url: {}, data: {}".format(url, data_dump))
        rsp = self.session.put(url, data=data_dump, timeout=5.0)

        if rsp.status_code >= 400:
            raise AssertionError("Mock server failed with {}: {}".format(rsp.status_code, rsp.text))

        return rsp
