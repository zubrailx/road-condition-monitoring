FROM python:3.11.9-alpine3.19

WORKDIR /app

COPY guessr/requirements.txt .
RUN pip install -r requirements.txt

COPY common ./common
COPY guessr/src ./guessr/src

ENTRYPOINT ["python", "-u", "guessr/src/main.py"]
