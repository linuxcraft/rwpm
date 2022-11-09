# Rofi wallpaper manager

Rofi wallpaper manager allowing you to automatically download, save and change
the wallpaper in 4k


| Rofi-wallpaper-manager                  |
|-----------------------------------------|
| ![img](.readme_static/demonstarion.gif) |

| Main interface                       | Advance download                        |
|--------------------------------------|-----------------------------------------|
| ![img](.readme_static/main_rofi.png) | ![img](.readme_static/advance_rofi.png) |

#### Notices:
| Downloading                                 | Saved                                  | Image already exists                    |
|---------------------------------------------|----------------------------------------|-----------------------------------------|
| ![img](.readme_static/notify_downloads.png) | ![img](.readme_static/notify_save.png) | ![img](.readme_static/notify_exist.png) |


## Instalation:
Clone the project and put it in the right folders
```
git clone https://github.com/linux-mastery/rwpm.git
cd rwpm
ln -sf ./rwpm.sh ~/.config/rofi/scripts/rwpm.sh
ln -sf ./swd.sh ~/.local/bin/swd
```

## Usage:
- Bind hotkey to run rwpm and use


## Requirements
- rofi
- feh
