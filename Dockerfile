FROM python
COPY app ./app
WORKDIR ./app
RUN pip3 install -r requirements.txt
RUN chmod u+x ./entrypoint.sh
ENTRYPOINT ["./entrypoint.sh"]
CMD [ "python", "run.py"]