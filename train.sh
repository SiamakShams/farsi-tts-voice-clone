#!/bin/bash
# train.sh - Train Farsi TTS model on custom voice

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}🎤 Farsi TTS Voice Clone - Training${NC}"
echo "======================================"
echo ""

# Activate virtual environment if it exists
if [ -d "tts-env" ]; then
    source tts-env/bin/activate
    echo -e "${GREEN}✓ Virtual environment activated${NC}"
fi

# Check dataset exists
if [ ! -d "dataset/wavs" ] || [ ! -f "dataset/metadata.csv" ]; then
    echo -e "${RED}❌ Dataset not found. Run 'python3 prepare_data.py' first.${NC}"
    exit 1
fi

# Get number of epochs from argument or use default
EPOCHS=${1:-100}

echo -e "${GREEN}✓ Dataset found${NC}"
echo "Training for $EPOCHS epochs..."
echo ""

# Run training
python3 train.py \
    --data_path ./dataset \
    --output_path ./my_finetuned_model \
    --epochs "$EPOCHS"

echo ""
echo -e "${GREEN}✅ Training complete!${NC}"
echo "Model saved to: my_finetuned_model/"
echo ""
echo "Next steps:"
echo "1. Test synthesis: bash synthesize.sh 'متن فارسی'"
echo "2. Or use batch: python3 batch_synthesize.py --text_file examples/sample_farsi_texts.txt"
echo "3. Or use web UI: bash run_webui.sh"
