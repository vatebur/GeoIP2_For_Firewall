#!/bin/bash

# 在OpenWrt的防火墙 - 自定义规则添加
# iptables -I INPUT -4 -m set --match-set china_ips src -j ACCEPT
# iptables -A INPUT -4 -j DROP

#添加集合
#ipset create china_ips hash:net


#URL="https://raw.githubusercontent.com/Hackl0us/GeoIP2-CN/release/CN-ip-cidr.txt"
URL="https://cdn.jsdelivr.net/gh/Hackl0us/GeoIP2-CN@release/CN-ip-cidr.txt"
V_IPSET_NAME=china_ips
DESTINATION="/root"


# 下载中国IP段数据
curl -LR -f -o "$DESTINATION/CN-ip-cidr.txt" "$URL"
if [ $? -ne 0 ]; then
        echo "$(date +"%Y-%m-%d %H:%M:%S") - 下载URL失败" >> $DESTINATION/log
        exit 1
fi
# 清空现有的ipset集合
ipset flush china_ips

# 添加自定义规则
#ipset add china_ips 192.168.xx.xx/24


# 将新的IP地址导入到ipset集合
while read -r line; do
    ipset add $V_IPSET_NAME $line
done < ~/CN-ip-cidr.txt

echo "$(date +"%Y-%m-%d %H:%M:%S") - 更新规则成功"
