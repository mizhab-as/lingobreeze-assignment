#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Keep track of the backend process ID
BACKEND_PID=""

# Cleanup function to kill the backend process when this script stops
cleanup() {
  if [ -n "$BACKEND_PID" ]; then
    echo ""
    echo "Stopping backend server (PID: $BACKEND_PID)..."
    kill "$BACKEND_PID" 2>/dev/null || true
  fi
}

# Trap exit signals to run the cleanup handler
trap cleanup EXIT INT TERM

echo "=================================================="
# Starting LingoBreeze Stack
echo "Starting LingoBreeze Stack..."
echo "=================================================="

# 1. Launch Backend
echo "Starting backend..."
cd backend

# Install node packages if not installed
if [ ! -d "node_modules" ]; then
  echo "Installing backend dependencies..."
  npm install
fi

# Run the backend in background and log to file
npm run start > backend.log 2>&1 &
BACKEND_PID=$!

# Wait 2 seconds for the server to bind port 3000
sleep 2

# Check if the process is still running
if ! kill -0 "$BACKEND_PID" 2>/dev/null; then
  echo "Error: Backend server failed to start."
  echo "Check backend/backend.log for detailed logs."
  exit 1
fi

echo "Backend started successfully in background (Logs: backend/backend.log)"

# 2. Launch Flutter App
echo ""
echo "Starting Flutter client..."
cd ../flutter-app

echo "Fetching Flutter dependencies..."
flutter pub get

echo "Launching Flutter application..."
flutter run
