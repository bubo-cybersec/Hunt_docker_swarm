FROM python:3.7-slim-bullseye

RUN apt-get update && apt-get install -y apt-utils curl git python3 python3-dev python3-venv python3-pip 

RUN git clone https://github.com/j91321/MISP2memcached.git

ENV VIRTUAL_ENV=/venv-misp2memcached
RUN python3 -m venv $VIRTUAL_ENV

ENV PATH="$VIRTUAL_ENV/bin:$PATH"
WORKDIR /MISP2memcached
RUN pip install -r /MISP2memcached/requirements.txt

RUN cp config.yml.example config.yml

RUN sed -i 's,url: https://127.0.0.1,url: https://10.99.1.100,g' config.yml ; \
    sed -i 's/PUT_MISP_TOKEN_HERE/ZzP3Vq39Tugi5bXos38EyxCGfIld7QKcfboNnPBT/' config.yml ; \
    sed -i 's/ignore_cert_errors: false/ignore_cert_errors: true/' config.yml ; \
    sed -i 's/host: 127.0.0.1/host: memcached/' config.yml

RUN chmod +x misp2memcached.py
CMD ["python", "./misp2memcached.py"]
VOLUME [ "/process_ioc.rb" ]