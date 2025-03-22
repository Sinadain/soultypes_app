#!/bin/bash

set -e  # Exit immediately if any command fails

OUTPUT_FILE="z.diagnostics.txt"
rm -f "$OUTPUT_FILE" # Remove any previous output file

# --- Section Separator ---
separator() {
    echo "#################################################"
    echo "### $1"
    echo "#################################################"
}

# Create output file and set up redirection
touch "$OUTPUT_FILE"

# Log start time to both terminal and file
separator "Start Time: $(date)" | tee -a "$OUTPUT_FILE"

# --- Flutter Analysis ---
{
  separator "Flutter Analysis"
  flutter analyze --no-congratulate --no-preamble --no-pub 2>&1 || true
} >> "$OUTPUT_FILE"

# --- Progress update to terminal ---
echo "Completed Flutter analysis, now launching test browser..." >&2

# --- Prepare Puppeteer environment ---
{
  separator "Preparing Test Environment"
  
  # Ensure diagnostics directory exists
  mkdir -p diagnostics
  
  # Check if package.json exists, if not create it
  if [ ! -f "diagnostics/package.json" ]; then
    cd diagnostics
    npm init -y > /dev/null 2>&1
    cd ..
  fi
  
  # Install puppeteer if needed
  cd diagnostics
  if [ ! -d "node_modules/puppeteer" ]; then
    echo "Installing Puppeteer (this may take a minute)..."
    npm install puppeteer --save
  else
    echo "Puppeteer already installed."
  fi
  cd ..
  
  echo "Test environment prepared."
} >> "$OUTPUT_FILE" 2>&1

# --- Launch Chrome Test Browser ---
{
  separator "Launching Chrome Test Browser"
  echo "Starting Chrome test browser. Please interact with the app to reproduce issues."
  echo "You can press Ctrl+C to end manually."
  echo ""
  
  # Run the puppeteer script from the diagnostics directory
  (cd diagnostics && export NO_TIMEOUT=1 && node capture_all.js)
  
  echo ""
} | tee -a "$OUTPUT_FILE"

# --- Process Console Log ---
{
  separator "Console Log Analysis"
  
  if [ -f "diagnostics/console_log.txt" ]; then
    echo "Console messages recorded:"
    grep -E '\[error\]|\[warning\]' diagnostics/console_log.txt || echo "No errors or warnings found in console log."
    
    # Count by type
    echo ""
    echo "Message count by type:"
    grep -o '\[[a-z]*\]' diagnostics/console_log.txt | sort | uniq -c | sort -nr
  else
    echo "No console log file found."
  fi
} >> "$OUTPUT_FILE" 2>&1

# --- Network Analysis ---
{
  separator "Network Analysis"

  if [ -f "diagnostics/network_log.json" ]; then
    echo "Network activity summary:"
    
    # Count requests
    echo "Total requests: $(grep -o '"url":' diagnostics/network_log.json | wc -l)"
    
    # Look for error responses
    echo "Error responses:"
    grep -B 5 -A 5 '"status":[45][0-9][0-9]' diagnostics/network_log.json || echo "No error responses found."
  else
    echo "No network log file found."
  fi
} >> "$OUTPUT_FILE" 2>&1

# --- End Timestamp ---
separator "End Time: $(date)" | tee -a "$OUTPUT_FILE"

# This message will be printed to the terminal
echo ""
echo "Diagnostics completed. Output written to $OUTPUT_FILE"
echo "Additional logs available in:"
echo "  - diagnostics/console_log.txt (Console messages)"
echo "  - diagnostics/network_log.json (Network requests)"
echo "  - diagnostics/network_log.har (HAR format network data)"
