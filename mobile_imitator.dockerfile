FROM python:3.11.9

RUN apt install gcc

WORKDIR /app

COPY mobile_imitator/requirements.txt .
RUN pip install -r requirements.txt

COPY common ./common
COPY mobile_imitator ./mobile_imitator

ENTRYPOINT ["python", "-u", "mobile_imitator/main.py"]
