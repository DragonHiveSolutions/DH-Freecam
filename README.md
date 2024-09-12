# Free Camera Mode Script for FiveM

![DH_Freecam_Banner](https://github.com/user-attachments/assets/ddcd8e11-f5e8-44a1-80ce-dc1c45da04db)

## Overview
This script enables a free camera mode in FiveM, allowing players to take screenshots or record videos without the HUD or other UI elements interfering. The camera can move freely within a configurable range, zoom in and out, and apply different visual filters. It also includes controls for rolling (tilting) the camera and hiding all HUD elements, including NUI elements added by other scripts.

## Features
* Free Camera Movement: Move the camera in any direction within a configurable range.
* Camera Zoom: Use the scroll wheel or Page Up/Down keys to zoom in and out.
* Camera Roll: Tilt the camera using the arrow keys.
* HUD and NUI Control: Hide all HUD and NUI elements for a clean screenshot or recording environment.
* Filter Effects: Cycle through different visual filters using the F1 key.
* Customizable: Easily configure the camera's range, movement speed, and more.

## Installation
1. Download the Script
Clone the repository or download it as a ZIP file and extract it.
``git clone https://github.com/yourusername/fivem-freecam.git``

2. Add to Your FiveM Server
Place the extracted folder in your FiveM server's resources directory.

3. Add to server.cfg
Open your server.cfg file and add the following line to ensure the script is loaded when the server starts:
``start dh-freecam``

4. Configure the Script
Open the config.lua file in the fivem-freecam folder to customize the camera settings, including the range, movement speed, and keybindings.

5. Starting the Script
The script will start automatically when the server is launched. Players can activate the free camera mode in-game using the command configured in config.lua (default is /freecam).

## Controls
* W/S: Move Forward/Backward
* A/D: Move Left/Right
* Q/E: Move Up/Down
* Scroll Wheel / Page Up/Down: Zoom In/Out
* Arrow Keys: Roll (Tilt) Camera Left/Right
* F1: Cycle through visual filters
* F2: Toggle on-screen control helpers
* /freecam: Activate/Deactivate the free camera mode

## Dependencies
This script is designed to be compatible with ESX and other common frameworks, but it should work in any FiveM server setup.

## Troubleshooting
If you encounter issues with the camera or UI elements not hiding, ensure that any other scripts are compatible with the NUI messages sent by this script. You may need to coordinate with the developers of other scripts to ensure full compatibility.

In cases of ESX or custom HUD scripts - You will need to either alter this script to disable the HUD using that script's functionality, or simply use ``stop HUDSCRIPTNAME`` and temporarily stop the HUD script to hide it.

## Contributing
Contributions are welcome! Feel free to submit a pull request or open an issue if you have suggestions or find a bug.

## License
See the LICENSE file for more details.
