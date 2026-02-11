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
