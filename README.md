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

[Keyword documentation for the latest release](https://etsi-cti-admin.github.io/docs/robotframework-mockserver.html)

See tests/robot/tests/mock_server.robot for detailed usage examples.

## Development

Prerequisites:

* docker-compose (to run integration tests)
* flake8 (for static code analysis)
* twine (release)
* robot-framework (for doc generation)

Install prerequisites (execute inside a python3 virtual environment):

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

Release process:

1. Increment version number in src/MockServerLibrary/version.py and commit the change
2. Tag the commit with the new version by issuing `make version/tag`
3. Push the commit and tag to Github (use `git push` with the `--follow-tags` option)
4. Publish the release to PyPI with `make release`
5. Clone the documentation repository to ../etsi-cti-admin.github.io
5. Generate the documentation with `make docs`
6. Publish then the resulting commit in ../etsi-cti-admin.github.io to Github
