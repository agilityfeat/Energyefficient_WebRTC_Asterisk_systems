# Energyefficient WebRTC Asterisk systems

Mapping the energy difference between a mesh and a SFU video mode setup


## Tools Used for the work

1. Webrtc client  : For the Webrtc SIP user agent to communicate with the SIP and media Server ( asterisk) I configured cyber_mega_phone_2k [1].  
2. Compute Pressure API  : For the experiments to record the CPU load and energy efficiency of the RTP topologies namely meshed, mixed and single forwarding I have used the Compute Pressure API [2]
3. Docker image for asterisk setup on docker engine [3]

    ![mage](screenshots/Screenshot%20from%202022-01-20%2008-16-25.png)

4. PJSIP-pjproject in Asterisk 
5. tcpdump to monitor the active calls

    
        tcpdump -s 0 udp port 5060 -w /home/ubuntu/sipserver_1.pcap


**References**
- [1] https://github.com/asterisk/cyber_mega_phone_2k
- [2] https://github.com/WICG/compute-pressure
- [3] https://docs.docker.com/engine/install/ubuntu/
- [4] https://wiki.asterisk.org/wiki/display/AST/PJSIP-pjproject
