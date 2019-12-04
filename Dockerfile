FROM python:3.8.0

# make docker user
RUN useradd -m docker && echo "docker:docker" | chpasswd && adduser docker sudo

# folders
RUN mkdir -p /staticfiles/media /staticfiles/static
RUN mkdir /logs
RUN mkdir /app
WORKDIR /app

RUN chown -R docker:docker /staticfiles
RUN chown -R docker:docker /logs
RUN chown -R docker:docker /app

# turn off bell
RUN echo 'set bell-style none' >> ~/.inputrc

RUN apt-get update
RUN apt-get install -y build-essential python3-dev \
        python3-setuptools python3-wheel python3-cffi libcairo2 libpango-1.0-0 \
        libpangocairo-1.0-0 libgdk-pixbuf2.0-0 libffi-dev shared-mime-info

ADD ./requirements.txt /app
RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r /app/requirements.txt

ADD ./backend /app/backend
ADD ./.env /app
WORKDIR /app/backend
RUN python3 manage.py collectstatic --noinput
