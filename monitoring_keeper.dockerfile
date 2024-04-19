FROM python:3.11.9

RUN apt install gcc

WORKDIR /app

COPY monitoring_keeper/requirements.txt .
RUN pip install -r requirements.txt

COPY common ./common
COPY monitoring_keeper ./monitoring_keeper

ENTRYPOINT ["python", "-u", "monitoring_keeper/main.py"]
