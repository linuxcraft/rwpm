#!/bin/bash

# github https://github.com/exynil/swd.git

# Set location where the wallpapers will be stored
location="$(pwd)"

# Set the resolution
# All: Do not include for all
# 5:4           = 1280x1024 1600x1280 1920x1536 2560x2048 3840x3072
# 4:3           = 1280x960 1600x1200 1920x1440 2560x1920 3840x2880
# 16:10         = 1280x800 1600x1000 1920x1200 2560x1600 3840x2400
# 16:9          = 1280x720 1600x900 1920x1080 2560x1440 2840x2160
# Ultrawide     = 2560x1080 3440x1440 3840x1600
atleast="1920x1080"

# Set the purity filter setting
# SFW           = 100
# Sketchy       = 010
# Both          = 110
# NOTE: Can combine them
purity="100"

# Set the category
# General       = 100
# Anime         = 010
# People        = 001
# NOTE: Can combine them
categories="110"

# Set the order
order="desc"

# Set the aspect ratio of the image
# All           = Do not include for all
# Square        = 1x1 3x2 4x3 5x4
# Portrait      = 9x16 10x16 9x18
# Wide          = 16x9 16x10
# Ultrawide     = 21x9 32x9 48x9
# NOTE: Can combine them by seperating with ,
ratios="16x9"

# Set the dominant colors of the image
# All           = Do not include for all
#
# #660000 #990000 #cc0000 #cc3333 #ea4c88 #993399
# #663399 #333399 #0066cc #0099cc #66cccc #77cc33
# #669900 #336600 #666600 #999900 #cccc33 #cccc33
# #cccc33 #ff9900 #ff6600 #cc6633 #996633 #663300
# #000000 #999999 #cccccc #ffffff #424153

# colors="424153"

# Set the site address
site="wallhaven.cc"

while [[ $# -gt 0 ]]; do
    key="$1"

    case $key in

    -C | --colors)
        colors="$2"
        shift
        shift
        ;;
    -q | --query)
        query="$2"
        shift
        shift
        ;;
    -a | --atleast)
        atleast="$2"
        shift
        shift
        ;;
    -p | --purity)
        purity="$2"
        shift
        shift
        ;;
    -c | --categories)
        categories="$2"
        shift
        shift
        ;;
    -r | --ratios)
        ratios="$2"
        shift
        shift
        ;;
    -s | --sorting)
        sorting="$2"
        shift
        shift
        ;;
    -o | --order)
        order="$2"
        shift
        shift
        ;;
    -l | --location)
        location="$2"
        shift
        shift
        ;;
    *)
        shift
        ;;
    esac
done

# Address for the wallpaper website
wallpaper_url="https://$site/search?"

[[ -n "$query" ]] &&  wallpaper_url+="q=${query// /+}"

[[ -n "$categories" ]] && wallpaper_url+="&categories=$categories"

[[ -n "$purity" ]] && wallpaper_url+="&purity=$purity"

[[ -n "$order" ]] && wallpaper_url+="&order=$order"

[[ -n "$colors" ]] && wallpaper_url+="&colors=$colors"

[[ -n "$ratios" ]] && wallpaper_url+="&ratios=$ratios"

[[ -n "$atleast" ]] && wallpaper_url+="&atleast=$atleast"

[[ -z "$query" ]] && wallpaper_url+="&page=$(("$RANDOM" % 30 + 1))"

case "$sorting" in
"latest") wallpaper_url+="&sorting=date_added" ;;
"views") wallpaper_url+="&sorting=views" ;;
"toplist") wallpaper_url+="&sorting=toplist" ;;
"favorites") wallpaper_url+="&sorting=favorites" ;;
*) wallpaper_url+="&sorting=random" ;;
esac

# Selected images
mapfile -t img_urls < <(curl -s "$wallpaper_url" | grep -oE 'https://'$site'/w/[[:alnum:]]{6}')

# Randomly selected image
rand_img_url=${img_urls[$RANDOM % ${#img_urls[@]}]}

# Parse out the image url
rand_img=$(curl -s "$rand_img_url" | grep -oE 'https://w.'$site'/full/[[:alnum:]]{2}/wallhaven-[[:alnum:]]{6}\.(jpg|png)')

if [ -z "$rand_img" ]; then
    notify-send -a "swd" -u critical "Failed to load wallpaper" -r 9997
    exit 1
fi

# Combine the two above
wallpaper="$location/${rand_img##*/}"

show_progress() {
    touch "$1"
    local_file_size=$(stat -c%s "$1")
    dest_file_size=$(curl -sI "$2" | grep -i 'Content-Length' | awk '{print $2}' | tr -d '\r')

    while [ "$local_file_size" != "$dest_file_size" ]; do
        percent=$(("$local_file_size"*100/"$dest_file_size"))
        notify-send -a "swd" --hint=string:x-dunst-stack-tag:swd -h int:value:$percent "$percent% Downloading..." -t 200 -r 9997
        local_file_size=$(stat -c%s "$1")
        sleep 0.1
    done
}

show_progress "$wallpaper" "$rand_img" &

# Download it
curl --create-dirs -s "$rand_img" -o "$wallpaper" >/dev/null

echo "$wallpaper"
