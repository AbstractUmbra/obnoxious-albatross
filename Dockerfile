# use slimmest python image
FROM python:3-alpine

LABEL org.opencontainers.image.source=https://github.com/abstractumbra/obnoxious-albatross
LABEL org.opencontainers.image.description="Obnoxious-Albatross hello world app"
LABEL org.opencontainers.image.licenses=MIT

WORKDIR /usr/src/app

# copy and install required dependencies
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py ./

# request run port
EXPOSE 8000

# we run on the 0.0.0.0 interface for outside container connectivity
CMD ["python", "-m", "flask", "run", "--host", "0.0.0.0", "--port", "8000"]
