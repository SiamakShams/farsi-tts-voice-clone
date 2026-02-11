# 🚀 Docker Quick Start - Farsi TTS Voice Clone

## One-Time Setup (15 minutes)

```bash
# 1. Clone and build
git clone https://github.com/SiamakShams/farsi-tts-voice-clone.git
cd farsi-tts-voice-clone

# 2. Build Docker image
DOCKER_BUILDKIT=1 docker build -t farsi-tts:latest .

# 3. Create data directory
mkdir -p ../data/raw_audio


# Verify setup
docker-compose run --rm farsi-tts setup

# Prepare data
docker-compose run --rm farsi-tts prepare /workspace/host_data/raw_audio dataset

# Train model
docker-compose run --rm farsi-tts train 100

# Synthesize speech
docker-compose run --rm farsi-tts synthesize "سلام دنیا"

# Batch synthesis
docker-compose run --rm farsi-tts batch /workspace/host_data/texts.txt /workspace/host_data/results

# Interactive shell
docker-compose run --rm farsi-tts shell

# Show help
docker-compose run --rm farsi-tts help
