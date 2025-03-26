FROM python:3.11
ENV PYTHONUNBUFFERED 1

RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get install -y nodejs npm

COPY ./requirements.txt /requirements.txt
RUN pip3 install -r /requirements.txt

RUN groupadd -r django && useradd -r -g django django
COPY . /app
RUN chown -R django /app

WORKDIR /app

RUN make install

USER django

RUN make build_sandbox

RUN cp --remove-destination /app/src/oscar/static/oscar/img/image_not_found.jpg /app/sandbox/public/media/

WORKDIR /app/sandbox/

RUN wget "https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-7.0.2.4839-linux-x64.zip" 
RUN unzip sonar-scanner-cli-7.0.2.4839-linux-x64.zip
#RUN mv sonar-scanner-7.0.2.4839-linux-x64/ /opt/sonar-scanner
#RUN export PATH=$PATH:/opt/sonar-scanner/bin'

CMD uwsgi --ini uwsgi.ini
