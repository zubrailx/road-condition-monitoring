FROM python:3.11.9

RUN apt install gcc

WORKDIR /app

COPY monitoring_loader/requirements.txt .
RUN pip install -r requirements.txt

COPY common ./common
COPY monitoring_loader ./monitoring_loader

ENTRYPOINT ["python", "-u", "monitoring_loader/main.py"]
