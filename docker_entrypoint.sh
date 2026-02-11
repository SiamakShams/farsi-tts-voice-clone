#!/bin/bash
# Docker entrypoint script for Farsi TTS Voice Clone
# Usage: docker run -it --rm -v $(pwd)/data:/workspace/host_data <image> <command> [parameters]

set -e

COMMAND=$1
shift

case "$COMMAND" in
    setup)
        echo "🚀 Setting up Farsi TTS Voice Clone"
        python3 verify_setup.py
        echo "✅ Setup verified!"
        ;;  
    
    prepare)
        if [ $# -lt 1 ]; then
            echo "❌ Usage: docker run -it --rm -v \\$(pwd)/data:/workspace/host_data <image> prepare <input_dir> [output_dir] [sample_rate]"
            echo "📝 Example: docker run -it --rm -v \\$(pwd)/data:/workspace/host_data <image> prepare /workspace/host_data/raw_audio dataset 22050"
            exit 1
        fi
        INPUT_DIR="$1"
        OUTPUT_DIR="${2:-dataset}"
        SAMPLE_RATE="${3:-22050}"
        
        echo "📌 Preparing Farsi audio data"
        python3 prepare_data.py --input_dir "$INPUT_DIR" --output_dir "$OUTPUT_DIR" --sample_rate "$SAMPLE_RATE"
        ;;  
    
    train)
        EPOCHS="${1:-100}"
        
        if [ ! -f "dataset/metadata.csv" ]; then
            echo "❌ Error: dataset/metadata.csv not found"
            echo "📝 Please run: docker run -it --rm -v \\$(pwd)/data:/workspace/host_data <image> prepare <input_dir>"
            exit 1
        fi
        
        echo "🎤 Training Farsi TTS model for $EPOCHS epochs"
        python3 train.py --data_path ./dataset --output_path ./my_finetuned_model --epochs "$EPOCHS"
        echo "✅ Training complete!"
        ;;  
    
    synthesize)
        if [ $# -lt 1 ]; then
            echo "❌ Usage: docker run -it --rm -v \\$(pwd)/data:/workspace/host_data <image> synthesize <text> [output_file]"
            echo "📝 Example: docker run -it --rm -v \\$(pwd)/data:/workspace/host_data <image> synthesize 'سلام دنیا' output.wav"
            exit 1
        fi
        
        TEXT="$1"
        OUTPUT="${2:-/workspace/host_data/output.wav}"
        
        if [ ! -f "my_finetuned_model/best_model.pth" ]; then
            echo "❌ Error: Trained model not found at my_finetuned_model/best_model.pth"
            echo "📝 Please train first: docker run -it --rm -v \\$(pwd)/data:/workspace/host_data <image> train"
            exit 1
        fi
        
        echo "🎤 Synthesizing: $TEXT"
        python3 synthesize.py --text "$TEXT" --model_path my_finetuned_model/best_model.pth --config_path my_finetuned_model/config.json --output_path "$OUTPUT"
        echo "✅ Synthesis complete! Output: $OUTPUT"
        ;;  
    
    batch)
        if [ $# -lt 1 ]; then
            echo "❌ Usage: docker run -it --rm -v \\$(pwd)/data:/workspace/host_data <image> batch <text_file> [output_dir]"
            echo "📝 Example: docker run -it --rm -v \\$(pwd)/data:/workspace/host_data <image> batch /workspace/host_data/texts.txt /workspace/host_data/results"
            exit 1
        fi
        
        TEXT_FILE="$1"
        OUTPUT_DIR="${2:-/workspace/host_data/batch_output}"
        
        if [ ! -f "my_finetuned_model/best_model.pth" ]; then
            echo "❌ Error: Trained model not found"
            echo "📝 Please train first: docker run -it --rm -v \\$(pwd)/data:/workspace/host_data <image> train"
            exit 1
        fi
        
        echo "🎤 Batch synthesizing texts from: $TEXT_FILE"
        python3 batch_synthesize.py --text_file "$TEXT_FILE" --output_dir "$OUTPUT_DIR"
        echo "✅ Batch synthesis complete! Output: $OUTPUT_DIR"
        ;;  
    
    verify)
        echo "🔍 Verifying setup"
        python3 verify_setup.py
        ;;  
    
    shell)
        echo "🐚 Entering interactive shell"
        /bin/bash
        ;;  
    
    help|"")
        cat << 'HELP'
🎤 Farsi TTS Voice Clone - Docker Commands

Usage: docker run -it --rm -v $(pwd)/data:/workspace/host_data <image> <command> [options]

Commands:
  setup              - Verify installation and setup
  prepare            - Prepare audio data for training
  train              - Train/fine-tune model on your voice
  synthesize         - Generate speech from Persian text
  batch              - Batch synthesize multiple texts
  verify             - Verify all dependencies
  shell              - Enter interactive shell
  help               - Show this help message

Examples:
  # Verify setup
  docker run -it --rm --gpus all -v $(pwd)/data:/workspace/host_data <image> setup

  # Prepare audio files
  docker run -it --rm --gpus all -v $(pwd)/data:/workspace/host_data <image> prepare /workspace/host_data/raw_audio dataset 22050

  # Train model (100 epochs)
  docker run -it --rm --gpus all -v $(pwd)/data:/workspace/host_data <image> train 100

  # Synthesize speech
  docker run -it --rm --gpus all -v $(pwd)/data:/workspace/host_data <image> synthesize "سلام دنیا"

  # Batch synthesize
  docker run -it --rm --gpus all -v $(pwd)/data:/workspace/host_data <image> batch /workspace/host_data/texts.txt /workspace/host_data/results

  # Interactive shell
  docker run -it --rm --gpus all -v $(pwd)/data:/workspace/host_data <image> shell

For detailed documentation, see DOCKER_README.md
HELP
        ;;  
    
    *)
        echo "❌ Unknown command: $COMMAND"
        echo "Run: docker run -it --rm <image> help"
        exit 1
        ;; 
esac
