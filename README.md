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

[Keyword documentation for the latest release](https://tyrjola.github.io/docs/robotframework-mockserver.html)

See tests/robot/tests/mock_server.robot for detailed usage examples.

## Development

Prerequisites:

* docker-compose (to run integration tests)
* flake8 (for static code analysis)
* twine (release)
* robot-framework (for doc generation)

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
