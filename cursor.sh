#!/bin/bash

# Script to download and install/update Cursor IDE
# Author: Geazzy Zanoni
# Date:  2025-07-04

set -euo pipefail

# API URL to get download information
API_URL="https://cursor.com/api/download?platform=linux-x64&releaseTrack=stable"

# Destination directory for the application
APPDIR="${HOME}/Applications/cursor-ide"
FINAL_APPIMAGE_NAME="cursor-ide.AppImage"
DESTINATION_PATH="${APPDIR}/${FINAL_APPIMAGE_NAME}"

# --- .desktop File and Icon Settings ---
ICON_FILENAME="cursor-ide.png"
ICON_URL="https://avatars.githubusercontent.com/u/126759922?s=48&v=4"
ICON_DEST_PATH="${APPDIR}/${ICON_FILENAME}"

DESKTOP_FILE_DIR="${HOME}/.local/share/applications"
DESKTOP_FILE_NAME="cursor-ide.desktop"
DESKTOP_FILE_PATH="${DESKTOP_FILE_DIR}/${DESKTOP_FILE_NAME}"
# --- End of .desktop File and Icon Settings ---

echo "Script to download and install/update Cursor IDE"
echo "---------------------------------------------------"
echo "Installation directory: ${DESTINATION_PATH}"
echo ".desktop file will be created at: ${DESKTOP_FILE_PATH}"
echo ""
echo "Fetching download information from: $API_URL"

# --- Dependency checks ---
for cmd in jq curl wget; do
  if ! command -v "$cmd" &> /dev/null; then
    echo "Error: '$cmd' not found. Please install it and try again."
    exit 1
  fi
done
# --- End of dependency checks ---

# --- Get Download URL ---
# -f fails on HTTP>=400, -s silences, -S shows error, -L follows redirects
JSON_RESPONSE=$(curl -fsSL "$API_URL")

if ! grep -q '"downloadUrl"' <<< "$JSON_RESPONSE"; then
  echo "Error: unexpected API response:"
  echo "$JSON_RESPONSE"
  exit 1
fi

DOWNLOAD_URL=$(jq -r '.downloadUrl' <<< "$JSON_RESPONSE")
if [[ -z "$DOWNLOAD_URL" || "$DOWNLOAD_URL" == "null" ]]; then
  echo "Error: could not get 'downloadUrl' from API response."
  echo "API response:"
  echo "$JSON_RESPONSE"
  exit 1
fi

echo "Download URL found: $DOWNLOAD_URL"
# --- End of URL retrieval ---

# Extract original filename
DOWNLOADED_FILENAME_ORIGINAL=$(basename "$DOWNLOAD_URL")
LOCAL_DOWNLOAD_PATH="./${DOWNLOADED_FILENAME_ORIGINAL}"

echo "File to be downloaded: ${DOWNLOADED_FILENAME_ORIGINAL}"
echo "Starting AppImage download..."

# Remove any previous download
rm -f "${LOCAL_DOWNLOAD_PATH}"

if wget --progress=bar:force "$DOWNLOAD_URL" -O "${LOCAL_DOWNLOAD_PATH}"; then
  echo ""
  echo "Download completed successfully!"
else
  echo ""
  echo "Error: failed to download '$DOWNLOAD_URL'."
  rm -f "${LOCAL_DOWNLOAD_PATH}"
  exit 1
fi

# --- Installation ---
echo "Verifying/creating destination directory: ${APPDIR}"
mkdir -p "${APPDIR}"
echo "Directory ready."

echo "Moving '${LOCAL_DOWNLOAD_PATH}' to '${DESTINATION_PATH}'"
mv "${LOCAL_DOWNLOAD_PATH}" "${DESTINATION_PATH}"
echo "File moved to ${DESTINATION_PATH}."

echo "Making '${DESTINATION_PATH}' executable..."
chmod +x "${DESTINATION_PATH}"
# --- End of Installation ---

# --- Icon Download ---
echo "Downloading icon from ${ICON_URL} to ${ICON_DEST_PATH}..."
if wget -q "$ICON_URL" -O "${ICON_DEST_PATH}"; then
  echo "Icon downloaded successfully."
else
  echo "Warning: failed to download icon; .desktop file will use default icon."
fi
# --- End of Icon Download ---

# --- .desktop File Generation ---
echo "Creating .desktop file at ${DESKTOP_FILE_PATH}"
mkdir -p "${DESKTOP_FILE_DIR}"

cat > "${DESKTOP_FILE_PATH}" << EOF
[Desktop Entry]
Version=1.1
Name=Cursor AI IDE
Comment=AI First Code Editor. Edit with AI.
GenericName=Text Editor
Exec=${DESTINATION_PATH} --no-sandbox %U
Icon=${ICON_DEST_PATH}
Type=Application
StartupNotify=true
StartupWMClass=Cursor
Categories=Development;IDE;TextEditor;
Keywords=vscode;cursor;ai;editor;ide;programming;
MimeType=text/plain;application/x-zerosize;inode/directory;
Actions=new-empty-window;

[Desktop Action new-empty-window]
Name=New Empty Window
Exec=${DESTINATION_PATH} --no-sandbox --new-window %U
Icon=${ICON_DEST_PATH}
EOF

chmod 644 "${DESKTOP_FILE_PATH}"

if command -v update-desktop-database &> /dev/null; then
  echo "Updating desktop application database..."
  update-desktop-database "${DESKTOP_FILE_DIR}"
  echo "Database updated."
else
  echo "Warning: 'update-desktop-database' not available. You may need to restart your session to see the shortcut."
fi
# --- End of .desktop File Generation ---

echo ""
echo "Cursor IDE installation/update completed successfully!"
echo "Run with: ${DESTINATION_PATH}"
echo "Or search for 'Cursor AI IDE' in your application menu."

exit 0
