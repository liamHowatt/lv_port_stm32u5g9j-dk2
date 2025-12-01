#!/usr/bin/env bash

set -e

echo stm32u5g9 build script

COMMAND=$1
CONFIG_PATH=$2
BOARD_NAME=$3
CONFIG_NAME=$4
SOCKET_PATH=$5

echo "COMMAND=$COMMAND CONFIG_PATH=$CONFIG_PATH BOARD_NAME=$BOARD_NAME CONFIG_NAME=$CONFIG_NAME SOCKET_PATH=$SOCKET_PATH"

cd lv_port_stm32u5g9j-dk2

sed -iE '
    /LV_USE_ST_LTDC\b/d;
    /LV_ST_LTDC_USE_DMA2D_FLUSH\b/d;
    /LV_USE_NEMA_GFX\b/d;
    /LV_USE_NEMA_VG\b/d;
    /LV_USE_DRAW_DMA2D\b/d;
    ' lv_conf.defaults

if [[ $CONFIG_NAME == ltdc-ltdcdma2dflush-nema-nemavg-16 ]]; then
    echo LV_USE_ST_LTDC 1                     >> lv_conf.defaults
    echo LV_ST_LTDC_USE_DMA2D_FLUSH 1         >> lv_conf.defaults
    echo LV_USE_NEMA_GFX 1                    >> lv_conf.defaults
    echo LV_USE_NEMA_VG 1                     >> lv_conf.defaults
    echo LV_USE_DRAW_DMA2D 0                  >> lv_conf.defaults
elif [[ $CONFIG_NAME == ltdc-dma2d-16 ]]; then
    echo LV_USE_ST_LTDC 1                     >> lv_conf.defaults
    echo LV_ST_LTDC_USE_DMA2D_FLUSH 0         >> lv_conf.defaults
    echo LV_USE_NEMA_GFX 0                    >> lv_conf.defaults
    echo LV_USE_NEMA_VG 0                     >> lv_conf.defaults
    echo LV_USE_DRAW_DMA2D 1                  >> lv_conf.defaults
else
    echo unexpected config name
    exit 1
fi

python3 lvgl/scripts/generate_lv_conf.py --config Core/Inc/lv_conf.h

make clean
make -j$(nproc)
