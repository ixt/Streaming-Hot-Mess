#!/bin/bash
#
#
# Youtube Video Downloader bash shell version
#
# usage: ./Download.sh video_id
#
# Condensed version for Streaming Hot mess by NfN Orange
# 2016/11/26
# Modified 2016 NfN Orange <orange@ff4500.red>
# Copyright 2013 Jacky Shih <iluaster@gmail.com>
#
# Licensed under the GNU General Public License, version 2.0 (GPLv2)
# This program is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License version 2 as published
# by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
# NON INFRINGEMENT.  See the GNU General Public License for more
# details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA.
#

wget "http://www.youtube.com/get_video_info?video_id=${1}" -qO- |\
    sed -e 's/&/\n/g' | grep 'url_encoded_fmt_stream_map' | sed -e 's/%2C/,/g' -e 's/,/\n/g' > .furls

if egrep -q "(video%252Fmp4%.*quality%3Dmedium(%|\n)|quality%3Dmedium%.*video%252Fmp4(%|\n))" .furls; then
    egrep "(video%252Fmp4%.*quality%3Dmedium(%|\n)|quality%3Dmedium%.*video%252Fmp4(%|\n))" .furls |\
        egrep 'http|sig%3D' |sed -e 's/%26/\&/g;s/&/\n/g' > .tmp5
fi

sed -e 's/\n//g;s/sig%3D/\&signature%3D/g;s/url%3D//g;s/%25/%/g;s/%25/%/g;
s/%3A/:/g;s/%2F/\//g;s/%3F/\?/g;s/%3D/=/g;s/%26/\&/g' .tmp5 > .tmp6

wget -O "${1}.mp4" -q --show-progress -i .tmp6

rm -f .tmp4 .tmp5 .tmp6 .furls
