# Python Project Template

Starter template for python projects

## Features

- environment management with Conda
- project metadata and dependency management with Poetry
- preconfigured continuous integration tasks
  - code formatting with isort and Black
  - code linting with isort, Black, Flake8 and Mypy
  - unit tests with pytest
  - pre-commit hooks
- application
  - logging with standard logging and python-json-logger
  - configuration with standard configparser, python-dotenv and pydantic
  - command line with Typer
  - web service with FastAPI, Uvicorn and Gunicorn
- deployment with Docker images
  - development image based on `python:latest`
  - lightweight production image based on `python:slim` using multi-stage build
- Make formula for common development tasks
  - install dependencies
  - run continuous integration tasks
  - run application
  - build Docker images

## Usage

Clone this repository or [use it as a template](generate) to generate a new repository.

Update the project name and metadata in `pyproject.toml` and `configs/main.ini`.

### Create environment

Use Conda to create a virtual environment and activate it for the project.

```bash
PROJECT_NAME = python-project-template
PYTHON_VERSION = 3.7

conda create --name $PROJECT_NAME --yes python=$PYTHON_VERSION
conda activate $PROJECT_NAME
```

### Install dependencies

Install Poetry with pip. Then install project dependencies with Poetry.

```bash
make deps-install
```

Use Poetry to add project and development dependencies into `pyproject.toml`.

NOTE: Poetry must be included as a development dependency to prevent
Poetry from uninstalling its own dependencies.

```bash
# development dependency
poetry add --dev poetry

# project dependency
poetry add pydantic
```

## Tools

- [Conda][conda]
- [Poetry][poetry]
- [isort][isort]
- [Black][black]
- [Flake8][flake8]
- [Mypy][mypy]
- [pytest][pytest]
- [pre-commit][pre-commit]
- [logging][logging]
- [python-json-logger][python-json-logger]
- [configparser][configparser]
- [python-dotenv][python-dotenv]
- [pydantic][pydantic]
- [Typer][typer]
- [FastAPI][fastapi]
- [Uvicorn][uvicorn]
- [Gunicorn][gunicorn]
- [Make][make]
- [Docker][docker]

[conda]: https://docs.conda.io/en/latest
[poetry]: https://python-poetry.org
[isort]: https://timothycrosley.github.io/isort
[black]: https://black.readthedocs.io/en/stable
[flake8]: https://flake8.pycqa.org/en/latest
[mypy]: http://www.mypy-lang.org
[pytest]: https://docs.pytest.org/en/stable
[pre-commit]: https://pre-commit.com/
[logging]: https://docs.python.org/3/library/logging.html
[python-json-logger]: https://github.com/madzak/python-json-logger
[configparser]: https://docs.python.org/3/library/configparser.html
[python-dotenv]: https://saurabh-kumar.com/python-dotenv
[pydantic]: https://pydantic-docs.helpmanual.io
[typer]: https://typer.tiangolo.com
[fastapi]: https://fastapi.tiangolo.com
[uvicorn]: https://www.uvicorn.org
[gunicorn]: https://gunicorn.org
[make]: https://www.gnu.org/software/make
[docker]: https://www.docker.com
