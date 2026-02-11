# Dockerfile

# Use the NVIDIA CUDA base image
FROM nvidia/cuda:11.4.2-cudnn8-runtime-ubuntu20.04

# Set the working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    python3.10 \
    python3.10-distutils \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install pip for Python 3.10
RUN curl -sS https://bootstrap.pypa.io/get-pip.py | python3.10

# Install TTS dependencies
COPY requirements.txt .
RUN pip install -r requirements.txt

# Download the TTS models
# Add your model download commands here, for example:
# RUN wget http://example.com/your_model_directory -P ./models/

# Copy the entrypoint script
COPY docker_entrypoint.sh .
RUN chmod +x docker_entrypoint.sh

# Set the entrypoint
ENTRYPOINT ["./docker_entrypoint.sh"]

# Default command
CMD ["help"]