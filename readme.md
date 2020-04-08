# The problem
A smart home device within a local network needs to access a specific Weather API via HTTP. However, the API pattern changed,
thus the request will not give the device appropriate responses anymore. Luckily, the DNS Server used by the smart home device can
be configured.

# The idea
Setup a DNS server, e.g. with Raspberry Pi.
Then route the domain of the Weather API to a web server that runs on the local address.

# The setup
- Raspberry Pi with Raspbian installed
- Pi-Hole as DNS server
  - The local network can benefit from Pi-Hole and it is easy to configure
  - Brings lighttpd
- lighttpd to integrate applications

# Benefits with that configuration
**Long story**
With that configuration it is possible to configure other local domains which point to a device within the local network.
The truth seems to be that there are a lot "smart" IP-devices which do not listen to names and therefore cannot be accessed by
names. That means, the more devices within a house the worse it becomes to maintain IP addresses for a layman 
(and an expert would start to curse or develop a solution)

**Short story**
- Only one entrypoint for DNS
- Easier to attach new IP devices and give them a network wide name
- If you are a developer, you can mock internet services to return desired responses to your home devices 

# Get started
1. Put a Raspbian version on an SD Card and start Raspberry-Pi
2. Install Pi-Hole https://github.com/pi-hole/pi-hole/#one-step-automated-install
3. Copy folder [scripts](scripts) to /home/pi
4. Set execute permission `chmod +x ~/scripts/*.sh`
4. Modify IP addresses in [add-application.sh](scripts/add-application.sh) to match the configured addresses during Pi-Hole
 installation

# Scripts
## Add local domain name
Execute the script `scripts/add-local-domain-name.sh` with a server description, IP address and domain name, e.g.
* `~/scripts/add-local-domain-name.sh nfs-server my.nfs.home 192.168.0.150` if IPv4 is enough for your local network or 
* `~/scripts/add-local-domain-name.sh nfs-server my.nfs.home 192.168.0.150 1a03:8070:f29d:1100:553c:1754::a` if you need IPv6, too.

## Add an application to configuration
Given as application name `weather-forecast` and domain `some.weather.com`
1. Add configuration files: `sudo ~/add-application.sh weather-forecast some.weather.com`
   * The script opens with nano some configuration files for you to re-check and because it was easier to develop the stupid
   routine of simply adding configuration lines to the lighttpd config. 
2. Reload lighttpd config: `sudo service lighttpd reload`
3. Restart pi-hole DNS: `sudo pihole restartdns`
