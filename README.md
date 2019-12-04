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

This package extends Model layer functionality, you simply describe, what model you would like to be indexed in ES, then the package tracks changes(I found problems in that part) and keeps ES sync with Postgres. In other words, we have duplicated data in both DBs, but in ES exactly the data, we want to be stored there and indexed. Like with DRF, which makes you have `serializers.py`, Dj ES DSL asks you to have `documents.py`, where you simply describe relations between models and documents(ES entities). So we work with search functionality like it's a 2nd Model layer in the pattern. Also it is possible to covert found ES data in to models queryset(Django model layer list of entities), so we can use it any were in Django.

Regarding the problem I found. The documentation of the Django Ealasticsearch DSL says, that every time we save an object of a model, for which we have document in terms of DE DSL, DE DSL saves it to ES. So we have synced data both places. Unfortunately, I did not aim this behavior on tests with the Car app. It may be, because I missed some settings parameter, or Django and DE DSL versions incompatibility(I'm using latest 2.x LTS Django version), any way, if the problem persists, the solution is to handle Django signal, emitted from just saved object, and sync PostgreSQL and ES. I also suggest to have the parameter of DE DSL explicitly off and to have our own parameter in the `settings.py`, which turns on/off our own signals handling, for a case, when the problem be fixed by package developers.

## Permissions restriction

There are two ways to implement that: on DRF permissions level, or selectors level, making decorator wrapper over them.
[See Django Styleguide](https://github.com/HackSoftware/Django-Styleguide#django-styleguide) for the answer about selectors.
