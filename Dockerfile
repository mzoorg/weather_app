FROM python
COPY app ./app
WORKDIR ./app
RUN pip3 install -r requirements.txt
CMD [ "python", "run.py"]