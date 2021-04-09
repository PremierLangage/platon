FROM python:3

# Set environment variables
# Prevents Python from writing pyc files to disc
ENV PYTHONDONTWRITEBYTECODE 1
# Prevents Python from buffering stdout and stderr (equivalent to python -u option)
ENV PYTHONUNBUFFERED 1

# Set work directory
WORKDIR /api

# Install dependencies
ADD platon-server/requirements.txt /api/requirements.txt
RUN python3 -m pip install --upgrade pip
RUN pip3 install wheel
RUN pip3 install -r requirements.txt

# Copy sources
ADD platon-server/apps /api/apps
ADD platon-server/platon /api/platon
ADD platon-server/shared /api/shared
ADD platon-server/manage.py /api/manage.py
