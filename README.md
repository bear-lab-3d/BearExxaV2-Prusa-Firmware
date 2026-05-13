# Prusa Firmware for BearExxa V2


## Table of contents
- [Description](#description)
- [Status](#status)
- [Disclaimer](#disclaimer)
- [Compatibility](#compatibility)
- [Installation and Configuration](#installation-and-configuration)
- [Modifications applied to the original Prusa firmware](#modifications-applied-to-the-original-prusa-firmware)
- [FAQ](#faq)
- [Developement](#developement)


## Description
This is the official firmware for the [BearExxa V2 extruder](https://github.com/gregsaun/BearExxa-V2) based on [Prusa-Firmware](https://github.com/prusa3d/Prusa-Firmware).


## Status
> [!CAUTION]
> The firmware and code provided in this repository isn't fully implemented nor tested yet. It could break your printer in case of issue!

More info in the section [Compatibility](#compatibility) below.


## Disclaimer
This firmware is a modified fork of the original Prusa Research firmware and is provided "AS IS" without any warranty, express or implied. By using this software, you acknowledge that 3D printing involves inherent risks including fire, equipment damage, and personal injury, and you assume full responsibility for all risks associated with its use. Under no circumstances shall the authors or contributors of this fork be liable for any damages arising from the use of this software; including but not limited to hardware failure, thermal issues, print failures, or property damage. It is your sole responsibility to ensure proper safety configurations, test thoroughly, and monitor your printer during operation.


## Compatibility

> [!IMPORTANT]
> Please read this section carefully

### Frame
- :white_check_mark: All official Bear frames
- :white_check_mark: Original Prusa frame

### Extruder / Print head
- :construction: Official BearExxa V2 MK3S(+) 2.0.0-beta.6 only [link](https://github.com/gregsaun/BearExxa-V2/releases/tag/2.0.0-beta.6)
- :construction: Official BearExxa V2 MK2.5S(+) 2.0.0-beta.6 only [link](https://github.com/gregsaun/BearExxa-V2/releases/tag/2.0.0-beta.6)
- :x: BearExxa V1
- :x: BearMera (E3D Hemera)
- :x: Bondtech Prusa extruder with Bear carriage
- :x: Original Prusa extruder


## Installation and configuration

### Firmware installation

1. Download the firmware according to your printer from the latest stable [release](../../releases)
2. Download and install the latest PrusaSlicer
3. Power on the printer, plug the USB cable and start PrusaSlicer
4. Flash the BearExxa V2 firmware following the [Prusa instructions](https://help.prusa3d.com/article/how-to-update-firmware-mk3s-mk3s-mk3_2227)
5. :grey_exclamation: important steps :  
    1. Shutdown the printer
    2. Press the LCD knob and **keep it pressed**
    3. Power on the pri ter
    4. When it beeps, immediatly relax the button. It will show a `Factory Reset` text
    5. After a second or two a menu appears, scroll down to **All Data** and click the knob
6. Follow the Wizard steps

### PrusaSlicer configuration

1. Open PrusaSlicer
2. In `Printers -> General -> Advanced` check **Prefer clockwise movements**. This will avoid the Revo nozzle to unscrew while printing
3. In `Printers -> Extruder 1 -> Retraction` set **Retraction length to 0.4mm**
4. In `Printers -> Custom G-code -> Start G-code`, comment these two lines at the end:  
`{if print_settings_id=~/.*(DETAIL @MK3|QUALITY @MK3).*/}M907 E430 ; set extruder motor current{endif}`  
`{if print_settings_id=~/.*(SPEED @MK3|DRAFT @MK3).*/}M907 E538 ; set extruder motor current{endif}`  
like this:  
`;{if print_settings_id=~/.*(DETAIL @MK3|QUALITY @MK3).*/}M907 E430 ; set extruder motor current{endif}`  
`;{if print_settings_id=~/.*(SPEED @MK3|DRAFT @MK3).*/}M907 E538 ; set extruder motor current{endif}`  
5. Save your printer profile!
6. Now you will need to update your filament profiles. For each filaments you are using:
    1. In `Filaments -> Filament Overrides -> Retraction` if you have checked and set a custom **Retraction length** then reduce it a little. 0.4mm for PLA and 0.6mm for PETG are good starting points
    2. We recommend to start with the Linear Advance (LA) disabled and tune it later with step iv. In `Filaments -> Custom G-code -> Start G-code` replace everything with **M900 K0**
    3. Re-tune the extrusion multiplier by following [our guide](https://guides.bear-lab.com/Guide/Extrusion+multiplier+and+filament+diameter/8?lang=en)
    4. Once the extrusion multiplier is set, we can now tune Linear Advance. If you have unsharp or bolby corners on your prints you can increase the K value by small steps, for example **M900 K0.01**. If the K value is too big you will see under extrusion and holes in the corners on solid infill. Be careful, this value will vary with filament materials and print speed. The K values for BearExxa are generally lower than the stock extruder values. More info [here](https://help.prusa3d.com/article/linear-advance_2252)

> [!TIP]
> If you like to customise your printer's start G-code, have a look at this [example in BearExxa-V2 extruder repository](https://github.com/gregsaun/BearExxa-V2/blob/main/extra/ps_startgcode_bear_mk3s_bex2.gcode).


## Modifications applied to the original Prusa firmware

Here is a list of all modifications we have applied to the original Prusa firmware. You can still find a backup of all modified files in the repository [./original_prusa](./original_prusa) for easy comparison.

### Splash Screen
- Status: :white_check_mark: MK3S+ | :construction: MK2.5S
- Reason: To make clear this is not the Original firmware and we added the Bear version

In **Marlin_main.cpp** we replaced the line
```C
lcd_printf_P(PSTR("\n Original Prusa i3\n   Prusa Research\n%20.20S"), PSTR(FW_VERSION));
```
with
```C
lcd_printf_P(PSTR("\n  Custom Prusa i3\n    BearExxa V2\n%20.20S"), PSTR(FW_VERSION_FULL));
```

### Printer name
- Status: :white_check_mark: MK3S+ | :construction: MK2.5S
- Reason: To avoid confusion with stock Prusa firmware and it is displayed in the *Support* LCD menu

In the **variant config file** (e.g.: MK3S.h), we have replaced the line
```C
#define CUSTOM_MENDEL_NAME "Prusa i3 MK3S"
```
with
```C
#define CUSTOM_MENDEL_NAME "Bear MK3S BEX2"
```

> [!NOTE]
> Where "BEX2" stands for **B**ear**EX**xa V**2**

### Firmware version
- Status: :white_check_mark: MK3S+ | :construction: MK2.5S
- Reason: To track version of the BearExxa V2 Prusa firmware

In **Configuration.h**, after the lines
```C
#ifndef CMAKE_CONTROL
#define FW_MAJOR 3
#define FW_MINOR 14
#define FW_REVISION 1
#define FW_COMMITNR 8237
//#define FW_FLAVOR RC      //uncomment if DEV, ALPHA, BETA or RC
//#define FW_FLAVERSION 1     //uncomment if FW_FLAVOR is defined and versioning is needed. Limited to max 8.
#endif
```
We have added the lines
```C
#undef FW_COMMITNR
#define FW_COMMITNR BEX201B1
```

> [!NOTE]
> The BEX201B1 name stands for **B**ear**EX**xaV**2** version **01B1**. The `01` value stands for the version 01 and `B1` for Beta 1. For an alpha release it would be A1, for an RC release would be R1 and for a stable release would be empty.

### Firmware repository
- Status: :white_check_mark: MK3S+ | :construction: MK2.5S
- Reason: To avoid confusion with stock Prusa firmware and it is displayed in the *Support* LCD menu

In **Configuration.h**, after the lines
```C
#ifndef CMAKE_CONTROL
#define FW_COMMIT_HASH_LENGTH 1
#define FW_COMMIT_HASH "0"
#define FW_REPOSITORY "Unknown"
#endif
```
We have added the lines
```C
#undef FW_REPOSITORY
#define FW_REPOSITORY "bear-lab-3d"
```
### Hotend name
- Status: :white_check_mark: MK3S+ | :construction: MK2.5S
- Reason: Displayed in the *Support* LCD menu

In the **variant config file** (e.g.: MK3S.h), we have replaced the line
```C
#define NOZZLE_TYPE "E3Dv6full"
```
with
```C
#define NOZZLE_TYPE "E3DRevoMicro"
```

### Z axis length for calibration
- Status: :white_check_mark: MK3S+ | Not available on MK2.5S
- Reason: BearExxa V2 is slightly taller for improved reliability and we need to adjust this to pass all tests and calibrations

In the **variant config file** (e.g.: MK3S.h), we have replaced the line
```C
#define Z_MAX_POS 210
```
with
```C
#define Z_MAX_POS 207
```
amd the line
```C
#define Z_MAX_POS_XYZ_CALIBRATION_CORRECTION 9
```
with
```C
#define Z_MAX_POS_XYZ_CALIBRATION_CORRECTION 3
```

### Hotend heatsink fan at full speed
- Status:  :white_check_mark: MK3S+ | Not available on MK2.5S
- Reason: BearExxa V2 is using a different fan that is incompatible with PWM and we prefer to run it at full speed for best hotend efficiency

In the **variant config file** (e.g.: MK3S.h), we have replaced the line
```C
#define EXTRUDER_ALTFAN_DETECT
```
with
```C
//#define EXTRUDER_ALTFAN_DETECT
```

### Extruder stepping
- Status:  :white_check_mark: MK3S+ | :construction: MK2.5S
- Reason: BearExxa V2 is using a gear ratio which impacts the number of steps of the filament gear to make a full turn

In the **variant config file** (e.g.: MK3S.h), we have replaced the line
```C
#define DEFAULT_AXIS_STEPS_PER_UNIT   {100,100,3200/8,280}
```
with
```C
#define DEFAULT_AXIS_STEPS_PER_UNIT   {100,100,3200/8,415}
```

> [!IMPORTANT]
> This is temporary until we sell a kit with our custom motor that will have a different gear ratio. The future estep will be 542.

### Extruder micro stepping
- Status:  :white_check_mark: MK3S+ | Not available on MK2.5S
- Reason: Due to the gear ratio the extruder stepper is running too fast so we need to reduce the microstepping to not overload the MCU

In the **variant config file** (e.g.: MK3S.h), we have replaced the line
```C
#define TMC2130_USTEPS_E    32
```
with
```C
#define TMC2130_USTEPS_E    16
```

### Default hotend PID
- Status: :white_check_mark: MK3S+ | :construction: MK2.5S
- Reason: BearExxa V2 is using a different hotend

In the **variant config file** (e.g.: MK3S.h), we have replaced the lines
```C
#define  DEFAULT_Kp 16.13
#define  DEFAULT_Ki 1.1625
#define  DEFAULT_Kd 56.23
```
with
```C
#define  DEFAULT_Kp 29.37
#define  DEFAULT_Ki 5.43
#define  DEFAULT_Kd 39.71
```

### Extruder motor currents
- Status: :white_check_mark: MK3S+ | todo MK2.5S
- Reason: BearExxa V2 motor is more efficient and therefore can use lower current to reduce heat transfer to the filament

In the **variant config file** (e.g.: MK3S.h), we have replaced the lines
```C
#define TMC2130_CURRENTS_H {16, 20, 35, 30}  // default holding currents for all axes
[...]
#define TMC2130_CURRENTS_R {16, 20, 35, 30}  // default running currents for all axes
#define TMC2130_CURRENTS_R_HOME {8, 10, 20, 18}  // homing running currents for all axes
```
with
```C
#define TMC2130_CURRENTS_H {16, 20, 35, 21}  // default holding currents for all axes
[...]
#define TMC2130_CURRENTS_R {16, 20, 35, 21}  // default running currents for all axes
#define TMC2130_CURRENTS_R_HOME {8, 10, 20, 15}  // homing running currents for all axes
```

> [!TIP]
For developers: In tmc2130.cpp there is a table to convert those current values into mA. Search for "@brief Translate current to tmc2130 vsense". It's also possible to activate service codes to set/get TMC2130 settings. In the variant config file, uncomment the line `//#define TMC2130_SERVICE_CODES_M910_M918`

### Disable thermal model
- Status: :white_check_mark: MK3S+ | Not available on MK2.5S
- Reason: The new thermal model with E3D Revo is unreliable (even on stock extruder with Revo Six). The older method is better 

In the **variant config file** (e.g.: MK3S.h), we have commented all the defines and the include related to thermal model:
```C
//#define THERMAL_MODEL 1
//#define THERMAL_MODEL_DEBUG 1
//#define THERMAL_MODEL_CAL_C_low 5
//#define THERMAL_MODEL_CAL_C_high 20
//#define THERMAL_MODEL_CAL_C_thr 0.01
//#define THERMAL_MODEL_CAL_C_itr 30
//#define THERMAL_MODEL_CAL_R_low 5
//#define THERMAL_MODEL_CAL_R_high 50
//#define THERMAL_MODEL_CAL_R_thr 0.01
//#define THERMAL_MODEL_CAL_R_itr 30
//#define THERMAL_MODEL_CAL_T_low 50
//#define THERMAL_MODEL_CAL_T_high 230
//#define THERMAL_MODEL_Ta_corr -7
//#include "thermal_model/e3d_v6.h"
//#define THERMAL_MODEL_DEFAULT E3D_V6
```

### Increase max X and Y motion speed to 300mm/s
- Status: :white_check_mark: MK3S+ | :construction: MK2.5S
- Reason: Useful for faster travel moves

In the **variant config file** (e.g.: MK3S.h), we have replaced the line
```C
#define DEFAULT_MAX_FEEDRATE                {200, 200, 12, 120}
```
with
```C
#define DEFAULT_MAX_FEEDRATE                {300, 300, 12, 120}
```

### Disable crash detection
- Status: :white_check_mark: MK3S+ | Not available on MK2.5S+
- Reason: Unreliable feature even on stock printers (e.g. see [#2653](https://github.com/prusa3d/Prusa-Firmware/issues/2653). Prusa also disables crash detection for the printers running in their farm. You can re-enable it in the LCD menu if you want

In the **Marlin_main.cpp**, we have replaced the line
```C
tmc2130_sg_stop_on_crash = eeprom_init_default_byte((uint8_t*)EEPROM_CRASH_DET, farm_mode ? false : true);
```
with
```C
tmc2130_sg_stop_on_crash = eeprom_init_default_byte((uint8_t*)EEPROM_CRASH_DET, farm_mode ? false : false);
```

### Disable fan check
- Status: :white_check_mark: MK3S+ | :construction: MK2.5S
- Reason: Beta version of BearExxaV2 uses the E3D Revo Micro fan which only has two wires

In the **variant config file** (e.g.: MK3S.h), we have replaced the line
```C
#define FANCHECK
```
with
```C
//#define FANCHECK
```

And to avoid any confusion we have disabled the fan check related LCD menus. In **ultralcd.cpp** we have replaced the line
```C
MENU_ITEM_TOGGLE_P(_T(MSG_FANS_CHECK), fans_check_enabled ? _T(MSG_ON) : _T(MSG_OFF), lcd_set_fan_check);
```
with
```C
//MENU_ITEM_TOGGLE_P(_T(MSG_FANS_CHECK), fans_check_enabled ? _T(MSG_ON) : _T(MSG_OFF), lcd_set_fan_check);
```
And the line
```C
MENU_ITEM_SUBMENU_P(_T(MSG_INFO_EXTRUDER), lcd_menu_extruder_info);
```
with
```C
//MENU_ITEM_SUBMENU_P(_T(MSG_INFO_EXTRUDER), lcd_menu_extruder_info);
```

> [!IMPORTANT]
> This is temporary until we sell a kit with a fan that has the 3rd tachometer wire.

> [!TIP]
> For developers: due to bugs in the original ALTFAN code, this only works if you undefine EXTRUDER_ALTFAN_DETECT in the variant file. See issue [4252](https://github.com/prusa3d/Prusa-Firmware/issues/4252).


## FAQ 

### Is it a calibration firmware like it was for BearExxa V1 ?
No it's a firmware made to be used in place of the original Prusa firmware. It has all the settings to run the BearExxa V2, pass the self test, wizard and all other calibrations as well as some light improvements for a better printing experience.

### How is the firmware tested?
We detail our test procedure in the section [Development -> Test](#test). We also have tests during the automated build sequence.

### Can I use the Original Prusa firmware instead?
Due to the many differences of the BearExxa V2 we do not recommend to use the original Prusa firmware. Our firmware is safer for the BearExxa V2.

### Can I use this firmware with BearExxa V1 and an E3D Revo Six hotend?
No it's not compatible.

### Can I use this firmware with the BearMera (E3D Hemera) and an E3D Revo hot side?
No it's not compatible.

### Can I use this firmware with the Bondtech Prusa extruder with Bear carriage and an E3D Revo Six hotend?
No it's not compatible.

### Why do I have to reset all my data after flashing the BearExxaV2 fimrware?
The BearExxa V2 firmware needs to change some settings stored in the persistent memory (EEPROM) that are usually kept through the Prusa firmware upgrades. We could have implemented deeper modifications but it would have increased the risk of bugs. Our approach is safer and, as you replace the extruder, you will have to run the tests and change the Live Z settings anyway. We have also seen some users experience issues after upgrading to one of the latest Original Prusa firmware due to old values in the EEPROM, a full reset solved these issues.


## Developement

### Rules
1. The code must be tested according to the section [Test](#test) below
2. The code must be documented with clear explanation of why the code is updated
3. The [README.md](/README.md) must be updated accordingly
4. AI code will be rejected


### Build
Ubuntu or Debian is recommended for the build.

#### Local build
```bash
# Install the dependencies
sudo apt-get install cmake ninja python3-pyelftools python3-polib python3-regex gettext

# clone the repository
git clone https://github.com/prusa3d/Prusa-Firmware
cd Prusa-Firmware

# automatically setup dependencies
./utils/bootstrap.py

# configure and build
mkdir build
cd build
sudo cmake .. -G Ninja -DCMAKE_BUILD_TYPE=Release -DCMAKE_TOOLCHAIN_FILE=../cmake/AvrGcc.cmake
sudo ninja
```

#### Build with GitHub Actions
Use the **bear_build_test** workflow and select the appropriate branch or tag.


### Test
1. Print a benchy with the latest BearExxa V2 firmware
2. Verify list of open bugs in the Prusa-Firmware repository
3. Flash new firmware
4. Check the firmware size
5. Reset all firmware data with the LCD menu
6. Run the Wizard
7. Run the Self test
8. Run the Z calibration
9. Run the XYZ calibration
10. Run first layer calibration
11. Change the LCD to a different language
12. Check M503 results, must correspond to [this for MK3S](bear_extra/tests/m503_results_mk3s.log)
13. Test firmware safeties using [this guide](https://guides.bear-lab.com/Guide/Checking+Firmware+Safety/25?lang=en)
14. Test every modifications that differ from the Original Prusa firmware
15. Test filament sensor
16. Print a benchy and compare with the one in the point 1
17. Do several prints of various projects
