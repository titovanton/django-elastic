# Elasticsearch integration in to the Django

## Project structure

Here is the list of only files which may confuse. Also the Django project structure listed here as well

- **backend** - *folder with Django project*
    - **apps** - *folder for Django apps(don't put __init__.py here!!!)*
        - **cars** - *ES testing app, going to be removed in a future*
    - **backend** - *main app with settings*
    - **runserver.sh** - *runserver shortcut for running within the docker*
- **.editorconfig** - *cross IDE settings file for different languages, there are plugins in PyCharm, Atom, Sublime, etc*
- **.env** - *environment file for docker containers*
- **.pep8** - *code style settings file*
- **docker-compose.yml** - *YAML settings for Docker cluster*
- **Dockerfile** - *to build backend(with Django) image*

Django folder I called by "backend" with purpose, that there may be "frontend" for example, or you may want to extend the project with Flask...
To keep project structure in good shape I suggest follow the guide:
[Django Styleguide](https://github.com/HackSoftware/Django-Styleguide#django-styleguide). I agree with that, except nested serializers. In a project MUST be file with `serializers.py` to prevent confuses.

## Docker-compose

I suggest to use Docker and in a future - to deploy with Kubernetes, to aim max identity of local, stage and production environments. Just in case, while we are using Docker, we do not need python virtual environment, because the Docker containers is the capsule itself. More then this, py virtualenv does not guarantee 100% cross platform deployment. Docker is much closer to 100%.

- `backend` - Django
- `postgres` v12.1-alpine
- `elastic` v7.5.0
- `flake` - code style tool, keeps you writing clean code. I use this way, because of specificity of my local build, you may use PyCharm/Atom plugin instead...

## Packages

Keep `requirements.txt` with hardcoded packages versions always! A years later, when the client would hire some other programmer, it will save his time and prevent package versions conflicts. Upgrading a package, make sure all tests are passed and of course, update `requirements.py`.

- `Django v2.2.8`, because of current Elasticsearch integration does not support 3.0.
- `Django Rest Framework for APIs`.
- `pytest` - tests engine
- `Faker and mommy` - robust population for test purposes.
- `Django Elasticsearch DSL` - Elasticsearch integration in to the Model layer, management commands, etc...

## Elasticsearch

It is possible to use "more-like-this" and "rank". Did not investigate in that yet, but have googled the first and saw an answer.

## Permissions restriction

There are two ways to implement that: on DRF permissions level, or selectors level, making decorator wrapper over them.
[See Django Styleguide](https://github.com/HackSoftware/Django-Styleguide#django-styleguide) for the answer about selectors.
