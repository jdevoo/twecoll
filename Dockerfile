FROM debian:latest

USER root

ENV DEBIAN_FRONTEND noninteractive
ENV PATH /twecoll:$PATH

RUN apt-get update
RUN apt-get install -y build-essential libxml2-dev zlib1g-dev python-dev python-pip pkg-config libffi-dev libcairo-dev git
RUN pip install python-igraph
RUN pip install --upgrade cffi
RUN pip install cairocffi

RUN git clone https://github.com/jdevoo/twecoll.git
ADD .twecoll /root

WORKDIR /app
VOLUME /app

ENTRYPOINT ["twecoll"]
CMD ["-v"]
