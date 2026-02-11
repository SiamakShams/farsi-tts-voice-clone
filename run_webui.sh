#!/bin/bash
# run_webui.sh - Start web UI for interactive synthesis

set -e

# Activate virtual environment if it exists
if [ -d "tts-env" ]; then
    source tts-env/bin/activate
fi

if [ ! -f "my_finetuned_model/best_model.pth" ]; then
    echo "❌ Model not found. Run 'bash train.sh' first."
    exit 1
fi

echo "🌐 Starting Coqui TTS Web UI..."
echo "Server will be available at: http://localhost:5002"
echo "Press Ctrl+C to stop"
echo ""

tts-server \
    --model_path my_finetuned_model/best_model.pth \
    --config_path my_finetuned_model/config.json \
    --port 5002
