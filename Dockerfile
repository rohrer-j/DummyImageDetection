# Use Ubuntu as the base image
FROM python

# create directory
RUN mkdir /service

# Copy only the requirements file first (this way it will not retrigger pip install if only .py file changes)
COPY requirements.txt /service/requirements.txt

WORKDIR /service

#install python packages
RUN python3 -m pip install --upgrade pip
RUN python3 -m pip install -r requirements.txt

# copy the source files
COPY src /service/src
COPY protofiles/ /service/protobufs   

#create folder for generated files
RUN mkdir generated

# Clean up to reduce image size
RUN apt-get clean && rm -rf /var/lib/apt/lists/*


EXPOSE 50051
ENTRYPOINT [ "python3", "src/app.py" ]