FROM python:3.9-slim as builder
WORKDIR /app
RUN apt-get update && apt-get install -y --no-install-recommends git
COPY requirements.txt .
RUN pip3 wheel --no-cache-dir --no-deps --wheel-dir /app/wheels -r requirements.txt
RUN git clone https://github.com/dvb6666/broadlink_ac_mqtt.git ac2mqtt

FROM python:3.9-slim
WORKDIR /app
COPY --from=builder /app/wheels /wheels
COPY --from=builder /app/requirements.txt .
RUN pip install --no-cache /wheels/*
COPY --from=builder /app/ac2mqtt /app/ac2mqtt
VOLUME /config
CMD ["python3", "/app/ac2mqtt/monitor.py" , "-c", "/config/config.yml"]
