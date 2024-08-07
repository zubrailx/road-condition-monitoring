FROM python:3.11.9

RUN apt install gcc

WORKDIR /app

COPY guessr/requirements.txt .
RUN pip install -r requirements.txt

COPY common ./common
COPY guessr/model ./guessr/model
COPY guessr/src ./guessr/src

ENTRYPOINT ["python", "-u", "guessr/src/points_inserter.py"]
