# Energyefficient WebRTC Asterisk systems

Mapping the energy difference between a mesh and a SFU video mode setup

## Setup and Installation

One can setup astrisk from theor online manual setup instriction [5]  or 
use the dockerfile given along with this project to setup a SFU webrtc enabled conferencing sip and media server.


## Configuration 

**httpd**

      [general]
      enabled=yes
      bindaddr=0.0.0.0
      bindport=8088               ; Port to bind to for HTTP sessions (default is 8088)
      tlsenable=yes               ; enable tls - default no.
      tlsbindaddr=0.0.0.0:8089    ; address and port to bind to - default is bindaddr and port 8089.
      tlscertfile=/etc/asterisk/keys/asterisk.crt
      tlsprivatekey=/etc/asterisk/keys/asterisk.key


Check status on console

*CLI> http show status
HTTP Server Status:
Prefix:
Server: Asterisk
Server Enabled and Bound to 0.0.0.0:8088

HTTPS Server Enabled and Bound to 0.0.0.0:8089

Enabled URI's:
/httpstatus => Asterisk HTTP General Status
/phoneprov/... => Asterisk HTTP Phone Provisioning Tool
/metrics/... => Prometheus Metrics URI
/ari/... => Asterisk RESTful API
/ws => Asterisk HTTP WebSocket

Enabled Redirects:
None.

Check status on web

![mage](screenshots/Screenshot%20from%202022-01-20%2011-47-02.png)

Endpoints with webrtc
![mage](screenshots/Screenshot%20from%202022-01-20%2010-02-16.png)

dialplan in /etc/asterisk/extensions.conf

      exten => 7000,1,Answer()
      same => n,ConfBridge(sfuconfbridge)
      same => n,Hangup()


Description of the endpoints in pjssip

      [sfuconfbridge]
      type=aor
      max_contacts=5
      remove_existing=yes
      
      [sfuconfbridge]
      type=auth
      auth_type=userpass
      username=altanai
      password=password
      
      [sfuconfbridge]
      type=endpoint
      aors=sfuconfbridge
      auth=sfuconfbridge
      dtls_auto_generate_cert=yes
      webrtc=yes
      ; Setting webrtc=yes is a shortcut for setting the following options:
      ; use_avpf=yes
      ; media_encryption=dtls
      ; dtls_verify=fingerprint
      ; dtls_setup=actpass
      ; ice_support=yes
      ; media_use_received_transport=yes
      ; rtcp_mux=yes
      context=default
      direct_media=no
      allow=!all,ulaw,vp8,h264
      max_audio_streams = 10
      max_video_streams = 10


*Note* To enable multi-stream support in the PSJIP channel set max_audio_streams and max_video_streams options 
for a given endpoint to any number between 2 and 16 ( highest)


Description of conf applications in /etc/asterisk/confbridge.conf 

      [default_bridge]
      type=bridge
      video_mode=sfu


*Note* : other types of Video modes besides SFU include first_marked and last_marked. 
Where the first and last used user to join the conference with video capabilities is the single source of video distribution among all participant
Also includes 'none' for no source and 'follow_talker'  which very interestingly looks for audio activity before switching the video to active speaker.

## For direct media
direct_media is used to enable p2p transport in extensions.conf

      [altanai]
      type=endpoint
      aors=altanai
      auth=altanai
      dtls_auto_generate_cert=yes
      webrtc=yes
      context=default
      direct_media=yes
      allow=!all,ulaw,vp8,h264
      max_audio_streams = 10
      max_video_streams = 10

And pjssip.conf

      direct_media=yes       ; Determines whether media may flow
      ; directly between endpoints (default: "yes")


## Tools Used for the work

1. Webrtc client  : For the Webrtc SIP user agent to communicate with the SIP and media Server ( asterisk) I configured cyber_mega_phone_2k [1].  

2. Compute Pressure API  : For the experiments to record the CPU load and energy efficiency of the RTP topologies namely meshed, mixed and single forwarding I have used the Compute Pressure API [2]
To activate goto chrome://flags/ and enable #enable-experimental-web-platform-features

   ![mage](screenshots/Screenshot%20from%202022-01-20%2010-06-41.png)

3. Docker image for asterisk setup on docker engine [3]

    ![mage](screenshots/Screenshot%20from%202022-01-20%2008-16-25.png)

4. Asterisk with PJSIP-pjproject  
5. tcpdump to monitor the active calls

    
        tcpdump -s 0 udp port 5060 -w /home/ubuntu/sipserver_1.pcap


**References**
- [1] https://github.com/asterisk/cyber_mega_phone_2k
- [2] https://github.com/WICG/compute-pressure
- [3] https://docs.docker.com/engine/install/ubuntu/
- [4] https://wiki.asterisk.org/wiki/display/AST/PJSIP-pjproject
- [5] 
