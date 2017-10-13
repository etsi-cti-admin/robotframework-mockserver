# MockServer Robot Framework Library

This project implements the Robot Framework keywords to interact with [MockServer](http://www.mock-server.com/) through HTTP.

## Installation

```sh
$ pip install robotframework-mockserver
```

## Usage

Add library to settings section:

```
*** Settings ***
Library  MockServerLibrary
```

Keyword documentation: WIP --> link will be added here

See tests/robot/tests/mock_server.robot for detailed examples.

## Development

Prerequisites:

* docker-compose (to run integration tests)
* flake8 (for static code analysis)
* twine (release)

Install prerequisites:

```sh
$ make setup
```

Print help:

```sh
$ make help
```

Start mock server and run tests:

```sh
$ make tester/test
```

Run lint:

```sh
$ make lint
```
