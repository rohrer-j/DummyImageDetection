# Use Ubuntu as the base image
FROM python as base

# Set working directory to the root of the project
WORKDIR /app

# Copy the requirement folder into the project
COPY requirements.txt /app

#install python packages
RUN python3 -m pip install --upgrade pip
RUN python3 -m pip install -r requirements.txt
#end of base steps

#---------------------------Debug stage-----------------------------------
FROM base as debug

# Install debugpy (Python debugger for remote debugging)
RUN python3 -m pip install debugpy

# Keeps Python from generating .pyc files in the container
ENV PYTHONDONTWRITEBYTECODE 1
# Turns off buffering for easier container logging
ENV PYTHONUNBUFFERED 1

# Expose the port for debugging
EXPOSE 5678
WORKDIR /app/src

FROM base as production

# Copy the src folder into the container for the production stage
COPY src/ /app/src

# Clean up to reduce image size
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /app/src
ENTRYPOINT [ "python3", "app.py" ]