# memhamwan-net-configs
# Execute with /import setup.rsc
# This script assumes that you've transferred a full set of RouterOS software and all appropriate user certificates
# after you execute this script, you need to do three things
# /system identity set name=YourCallsign
# /interface wireless set 0 radio-name="YourCallsign"
# /console clear-history










# Functions
#------------


# Prompt: Puts a prompt on the command line, then accepts an input from the user.
# Input array:
#   0 = prompt to display
#   1 = echo typed input (0 - default) or hide (1)
# Output array:
#   0 = input from user
:global Prompt ":local output \"\"
            :set input [:toarray \$input]
            :if ([:len \$input] > 0) do={
                :local input1 [:tostr [:pick \$input 0]]
                :local echo 0
                :if ([:len \$input] > 1) do={ 
                    :set echo [:tonum [:pick \$input 1]]
                }
                :local asciichar (\"0,1,2,3,4,5,6,7,8,9,\" . \
                                  \"a,b,c,d,e,f,g,h,i,j,k,l,\" . \
                                  \"m,n,o,p,q,r,s,t,u,v,w,x,y,z,\" . \
                                  \"A,B,C,D,E,F,G,H,I,J,K,L,\" . \
                                  \"M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,\" . \
                                  \".,/\")
                :local asciival {48;49;50;51;52;53;54;55;56;57; \
                                 97;98;99;100;101;102;103;104;105;106;107;108; \
                                 109;110;111;112;113;114;115;116;117;118;119;120;121;122; \
                                 65;66;67;68;69;70;71;72;73;74;75;76; \
                                 77;78;79;80;81;82;83;84;85;86;87;88;89;90; \
                                 46;47}
                
                :local findindex;
                :local loop 1;
                :local key 0;
                :put \"\$input1\";
                :while (\$loop = 1) do={
                
                    :set key ([:terminal inkey])
                    
                    :if (\$key = 8) do={
                        :set output [pick \$output 0 ([:len \$output] -1)];
                        :if (\$echo != 1) do={
                            :put \"\r\$output              \";
                            /terminal cuu 0;
                        } else={
                            :local stars;
                            :if ([:len \$output] > 0) do={
                                :for x from=0 to=([:len \$output]-1) do={
                                    :set stars (\$stars . \"*\");
                                }    
                            }
                            :put \"\r\$stars                         \";
                            /terminal cuu 0;
                        }
                    }
                    
                    :if (\$key = 13) do={
                        :set loop 0;
                        put \"\";
                        } else={
                           
#                       # Convert numeric ascii value to ascii character
                        :set findindex [:find [:toarray \$asciival] \$key]
                        :if ([:len \$findindex] > 0) do={
                            :set key [:pick [:toarray \$asciichar] \$findindex]
                            :set output (\$output . \$key);
                            :if (\$echo != 1) do={
                                :put \"\r\$output                \";
                                /terminal cuu 0;
                            } else={
                                :local stars;
                                :for x from=0 to=([:len \$output]-1) do={
                                    :set stars (\$stars . \"*\");
                                    }
                                                            
                                :put \"\r\$stars                     \";
                                /terminal cuu 0;
                            }
                        }
                    }
                }
                :set output [:toarray \$output]
            };"
                


# -----------------
# End Functions








:put "Configuring your radio for HamWAN"

:global ROSver value=[:tostr [/system resource get value-name=version]];
:global ROSverH value=[:pick $ROSver 0 ([:find $ROSver "." -1]) ];
:global ROSverL value=[:pick $ROSver ([:find $ROSver "." -1] + 1) [:len $ROSver] ];
:if ([:len $ROSverL] < 2) do={ set $ROSverL value=("0".$ROSverL) };

:global ROSverN value=[:tonum ($ROSverL.$ROSverL)];
:if ($ROSverN < 600) do={
:error "Please update RouterOS to at least major version 6 to continue"
};

:put [/user add group=full name=ryan_turner password=]
:put [/user ssh-keys import public-key-file=ryan_turner_dsa_public.txt user=ryan_turner]
:put [/user add group=full name=ns4b password=]
:put [/user ssh-keys import public-key-file=ns4b_dsa_public.txt user=ns4b]
:put [/system logging action set 3 bsd-syslog=no name=remote remote=44.34.128.21 remote-port=514 src-address=0.0.0.0 syslog-facility=daemon syslog-severity=auto target=remote]
:put [/system logging add action=remote disabled=no prefix="" topics=!debug,!snmp]
:put [/snmp set enabled=yes contact="#HamWAN on irc.freenode.org"]
:put [/snmp community set name=hamwan addresses=44.34.128.0/28 read-access=yes write-access=no numbers=0]
:put [/ip dns set servers=44.34.132.1,44.34.133.1]
:put [/system ntp client set enabled=yes primary-ntp=44.34.132.3 secondary-ntp=44.34.133.3]
:put [/ip firewall filter remove [find]]
:put [/ip dhcp-server remove [find]]
:put [/ip dhcp-server network remove [find]]
:put [/ip address remove [find]]
:put [/ip dns set allow-remote-requests=no]
:put [/ip firewall mangle add action=change-mss chain=output new-mss=1378 protocol=tcp tcp-flags=syn tcp-mss=!0-1378]
:put [/ip firewall mangle add action=change-mss chain=forward new-mss=1378 protocol=tcp tcp-flags=syn tcp-mss=!0-1378]
:put [/interface wireless channels add band=5ghz-onlyn comment="Cell sites radiate this at 0 degrees (north)" frequency=5920 list=HamWAN name=Sector1-10 width=10]
:put [/interface wireless channels add band=5ghz-onlyn comment="Cell sites radiate this at 120 degrees (south-east)" frequency=5900 list=HamWAN name=Sector2-10 width=10]
:put [/interface wireless channels add band=5ghz-onlyn comment="Cell sites radiate this at 240 degrees (south-west)" frequency=5880 list=HamWAN name=Sector3-10 width=10]
:put [/interface wireless set 0 disabled=no frequency-mode=superchannel scan-list=HamWAN ssid=HamWAN wireless-protocol=nv2]
:put [/ip dhcp-client add add-default-route=yes dhcp-options=hostname,clientid disabled=no interface=wlan1]


# Prompt for password - mask characters typed
    :local password;
    :set runFunc [:parse (":global password;" . \
             ":local input \"Enter new admin password or leave blank to skip:,1\";" . \
                       $Prompt . \
             ":set password \$output")
         ]
        
    $runFunc;
    
    if ([:len $password] > 0) do={ /user set admin password=$password }
# Prompt for callsign
    :local callsign;
    :set runFunc [:parse (":global callsign;" . \
             ":local input \"Enter your callsign:\";" . \
                       $Prompt . \
             ":set callsign \$output")
         ]

    $runFunc;

    if ([:len $callsign] > 0) do={ /interface wireless set 0 radio-name=$callsign; \
        /system identity set name=$callsign;
    }






:put [/system reboot]
