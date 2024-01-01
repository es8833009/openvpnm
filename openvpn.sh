sed -i '/DEFAULT_FORWARD_POLICY/c DEFAULT_FORWARD_POLICY="ACCEPT"' /etc/default/ufw

----------------------------------------------

vim /etc/sysctl.conf

sed -i s/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g /etc/sysctl.conf && sysctl -p
修改为
net.ipv4.ip_forward=1

执行生效:

sysctl -p

sed -i s/DEFAULT_FORWARD_POLICY="DROP"/DEFAULT_FORWARD_POLICY="ACCEPT"/g /etc/default/ufw
2.------
vim /etc/default/ufw

DEFAULT_FORWARD_POLICY="DROP"

修改为

DEFAULT_FORWARD_POLICY="ACCEPT"


3.---------
mkdir -p  /etc/sysconfig
vim /etc/sysconfig/iptables

*nat
-A POSTROUTING -j MASQUERADE
-A INPUT -p udp -m udp --dport 21194 -j ACCEPT
-A  INPUT -s 10.8.0.0/255.255.255.0 -j ACCEPT


-A PREROUTING -d 148.135.15.145 -p tcp -m tcp --dport 3000:50000 -j DNAT --to-destination 10.8.0.2
-A POSTROUTING -p tcp -m tcp --dport 3000:50000 -j MASQUERADE

COMMIT  

-------or----

*nat
-A POSTROUTING -j MASQUERADE
-A INPUT -p udp -m udp --dport 21194 -j ACCEPT
-A  INPUT -s 10.8.0.0/255.255.255.0 -j ACCEPT

-A PREROUTING -d 10.170.0.9 -p tcp -m tcp --dport 3000:65535 -j DNAT --to-destination 10.8.0.2
-A POSTROUTING -p tcp -m tcp --dport 3000:65535 -j MASQUERADE

COMMIT

~                                                                                                                                                                                                        
~    
4.---------

iptables-restore < /etc/sysconfig/iptables


echo "
*nat
-A POSTROUTING -j MASQUERADE
-A INPUT -p tcp -m tcp --dport 61194 -j ACCEPT
-A  INPUT -s 10.8.0.0/255.255.255.0 -j ACCEPT

-A PREROUTING -d 10.170.0.4 -p tcp -m tcp --dport 5052:5052 -j DNAT --to-destination 10.8.0.2
-A POSTROUTING -p tcp -m tcp --dport 5052:5052 -j MASQUERADE

-A PREROUTING -d 10.170.0.4 -p tcp -m tcp --dport 9000:9000 -j DNAT --to-destination 10.8.0.2
-A POSTROUTING -p tcp -m tcp --dport 9000:9000 -j MASQUERADE

-A PREROUTING -d 10.170.0.4 -p udp -m udp --dport 9000:9000 -j DNAT --to-destination 10.8.0.2
-A POSTROUTING -p udp -m udp --dport 9000:9000 -j MASQUERADE

COMMIT

" > /etc/sysconfig/iptables
