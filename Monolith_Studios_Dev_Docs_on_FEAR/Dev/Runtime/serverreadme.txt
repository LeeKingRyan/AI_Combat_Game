F.E.A.R.(TM) Extraction Point Standalone Server
Readme File
July 2, 2006

***************************************************************************

About This Document:

This document contains information about setting up and running the
F.E.A.R. Extraction Point Standalone Server application as well as important
information for multiplayer hosts. Please be sure to read the readme.txt
file included on your CD before attempting to run a dedicated server.

Note that F.E.A.R. Extraction Point is a seperate product that requires
the F.E.A.R. install and data to run, but does use it's own user data
directory (with it's own set of server customizations).

***************************************************************************

TABLE OF CONTENTS

I.	System Requirements
II.	Setting up your Server
III.	Running a Server
IV.	The SCMD System
V.	SCMD Commands
VI.	Console commands
VII.	Advanced Server Customizations
VIII.	Custom Content
IX.	Limiting Bandwidth
X.	Recommended Player Limits
XI.	Dedicated Servers and incompatible video cards
XII.	PunkBuster
XIII.	End-User License Agreement (EULA)


I. System Requirements
===========================================================================

The following items are required to run a F.E.A.R. Extraction Point dedicated
server:

1. A broadband Internet connection or LAN connection*
2. A system that meets or exceeds the minimum system requirements for the
game as described in the readme.txt file.
3. F.E.A.R. Extraction Point must be installed to a sub-directory of F.E.A.R.

NOTE: It is possible to run a dedicated server on a machine with a video
card that does not meet the requirements for the full game. Please see
the section near the bottom of this document entitled "Dedicated servers
and incompatible video cards" for details.

*Clients may have trouble connecting to servers behind certain firewalls
or NATs.

II. Setting up your Server
===========================================================================

To set up a server, just follow these steps:

1. Launch the game application (FEARXP.exe)
2. Select "Multiplayer" from the main game menu.
3. Select "Host" from the multiplayer menu.
4. Set up the game type, server name, options, and map rotation.
5. Set your network port, or use the default port of 27888.
6. For the Dedicated Server option, select Yes. 
7. Click Launch. 

The game application will now close, and the standalone server application
will start. Once your server is running, clients can search for and join it
in the same way they would a normal host.  

Once your server has been configured and launched through the game interface
for the first time, you can run your server again at any time by double
-clicking the "FearServerXP.exe" file in your F.E.A.R. Extraction Point
installation folder. 

If you wish to make any changes to the server setup, you'll need to launch
the game application again and change your settings through the host game
interface. 

NOTE: Server options can be saved off in separate configuration files
through the Load/Save options section of the host menu. If you have more
than one server options file saved, you will be prompted to select the one 
you wish to use each time you launch the dedicated server application. 

If you are running your server from a batch file or the command line and
you want to specify which profile to use, add "-optionsfile (optionfilename)" to
the command. So, for instance, if your server option file is called "config1"
then add this line to your batch file:

FEARServerXP.exe -optionsfile config1

The -optionsfile switch will also recognize a full path as an argument.  For
example, to use the configuration file "c:\fearxp\myoptions.txt", use the following
syntax:

FEARServerXP.exe -optionsfile c:\fearxp\myoptions.txt

By default, the server looks in the following directory for configuration files
and other user content:

C:\Documents and Settings\All Users\Documents\TimeGate Studios\FEARXP
(from the windows browser you will need to select 'Shared Documents')

This is known as the "user directory".  It is possible to change the user
directory for the server by specifying the "-userdirectory (path)" command line 
option.  For example, to launch the dedicated server with a user directory of 
"c:\fearxp\user", use the following command: 

FEARServerXP.exe -userdirectory c:\fearxp\user

This directory behaves exactly like the default user directory, meaning that 
the server will look for files in the same subdirectories as those in the 
default user directory.  For example, to use a server options file in the 
directory specified by the -userdirectory option, you must create a 
"ServerOptions" subdirectory and place any options files there. Note that 
several subdirectories will be automatically created beneath the user directory.

NOTE: If you wish to run more than one dedicated server on the same computer, 
you must specify unique port numbers for each.


III. Running your Server
===========================================================================

When the server starts running there are five tabs across the top and a 
button at the bottom.  


STOP SERVER: 	This will shut down the server. 


STATS
-----------

SERVER NAME:	This is the name of your server as seen by players when
		they are searching for servers to join.  

VERSION:	The game version the server is running on.

MOD:		The mod used by the game server.

GAME TYPE:  	Displays the game mode that the server is currently
		running, such as Deathmatch or Demolition. 

MAP:		The current map.

SERVER CONFIG:	The current server profile.

RUNNING TIME:	The time elapsed since the server was launched. 

TIME IN LEVEL:	The time elapsed since the current round started. 

PEAK PLAYERS: 	This shows the highest number of players that were on
		your server at one time.

TOTAL PLAYERS:	This shows the total number of players that have joined
		your server since it was last launched.

UNIQUE PLAYERS:	The number of unique names that have joined during since
		the server launched.

AVERAGE PING:  	The average ping of the players currently connected to
		your server.

RULES
-----

This is a summary all the game settings used when the server launched.
You may change some of these settings while your server is running, but
options that are greyed out can only be changed through the game
interface before the server is launched.

This section is also where the Server Message and Briefing Override
messages can be set.

MAPS
----

This window shows a list of levels in the order in which they will be
loaded by the server. The current level is indicated with a black dot
to the left of its name.

Next level:	Ends the current level and immediately loads the next.

Select level:	Ends the current level and immediately loads the
		highlighted level. Double clicking on the map name
		will have the same effect.

PLAYERS
-------

PLAYERS:	This section provides information about the players that
		are currently connected to the server, including their
		player name, ping, kills, deaths, score, and the time elapsed
		since they began playing. 

BOOT PLAYER:  	Clicking this button will disconnect the player whose
		name is currently highlighted. To highlight a player
		name, just click on it. 

CONSOLE
-------

This shows a scrolling display of the server's internal commands and status.
Player chat, connections, disconnections, and other text is also displayed
here. 

You can use the console to enter commands to control and maintain your
server. Please see the SCMD and advanced commands sections below for more
information on this topic. 


IV. THE SCMD SYSTEM
===========================================================================

The SCMD interface is used to execute server side commands through a text
based console. SCMD sends commands to the server to control settings from
the hosting client, a remote client or the standalone server. It offers a
generalized user interface that works on all three of these entry points.
On a hosted or remote client, commands are entered through the chat
interface. On the Stand-alone server, commands are entered through the
console interface. 

To use SCMD, just follow these steps:

1. Before launching your server (either hosted or dedicated), set the
   "Allow SCMD" option to "Yes" and then specify a password. 
2. Launch the server.
3. Type SCMD and press <Enter> on the command line of your dedicated
   server, or in the chat interface on a host or client to see a list of
   available commands. You will need to scroll up to see the entire list. 
4. Log in to the system by typing SCMD followed by the password that you
   specified in the host options. 

Once you have successfully logged in, you can then use any of the other
SCMD commands. Note that only one host or client can be logged into the
system at once. The format for all SCMD commands is:

SCMD command [arg1] [...]

Example:  You are logged into SCMD through a client connected to a
dedicated server, and one of the other players becomes abusive. With SCMD,
you can boot the player through your client like this:

Type "SCMD listclients". This will display text similar to the following:

Client List format: clientid) [name][ping][ip]
0) [Smiley][0][0.0.0.0]
1) [Cheater][80][123.456.789.012]
2) [Player0][120][321.654.987.210]

From here, you can type "SCMD bootname Cheater", or "SCMD bootid 1" to
remove the problem player from the server. 

Then, if the player logs in again and continues to cause trouble, you can
ban the user from the server by using the "banuser" command.  For example,
to ban the user "Cheater" from the list above, type "SCMD banuser 1". 

In addition to user banning, IP address banning is also supported.  This
is done by adding entries to the following IP banning file:

C:\Documents and Settings\All Users\Documents\TimeGate Studios
\FEARXP\BanIPList.txt

To add a banned IP address to the list, edit the file and add the address
to the end, on its own line.  The game server must be restarted for this 
change to take effect.  Note that IP address banning is not as effective as
user banning.  Banning an IP address may actually ban many players from the 
server if they share a common network router.  In addition, the same user
can potentially access the server from different IP addresses, so it may
be possible for the user to reconnect with a different address.  In most
cases, the "SCMD banuser" command described previously is preferable to
banning by IP address.

For a full list of commands, please see the section below. 

V. SCMD COMMANDS
===========================================================================

Following is the list of commands currently supported by SCMD:

Command		Parameter		Description
---------------------------------------------------------------------------
HELP					List all available SCMD commands.
LOGIN 		<password>		Logs in as SCMD Administrator.
LOGOUT					Logs out as SCMD Administrator.
LISTCLIENTS				Displays list of clients.
LISTMAPS				List all current maps.
NEXTMAP					Go to next map in the map list.
NEXTROUND				Go to next round for this level.
SETMAP		<map_index>		Advances to map_index.
BOOTNAME 	<playername>		Boots client by player name.
BOOTID		<clientid>		Boots client by client id.
BANUSER		<clientid>		Bans a user by client id.
UNBANUSER	<banid>			Removes a user ban by banid.
LISTUSERBANS				Lists all currently banned users.
LISTGAMEOPTIONS				Lists game options.
SHOWGAMEOPTION	<optionid>		Shows details on a game option.
SETGAMEOPTION	<optionid> <value> 	Sets game option by optionid.

Please note that when using SCMD from a remote client, changes made to game
options will not be visible with the listgameoptions or showgameoption
commands.


VI. CONSOLE COMMANDS
===========================================================================

Advanced commands can only be entered via the dedicated server command line
and not through the SCMD interface.  

Command			Description
---------------------------------------------------------------------------
Say			Allows the server operator to chat with players.
			Chat text must be contained within quotes.

BandWidthTargetServer	Target bits per second to send over the network
			layer. This MUST be set correctly to avoid send
			overflow. For a detailed explanation of how to use
			this feature, please see the section of this
			document titled "Limiting Bandwidth".


VII. Advanced Server Customizations
===========================================================================

Server operators can customize the F.E.A.R. Extraction Point multiplayer 
experience on a server by editing the following file:

C:\Documents and Settings\All Users\Documents\TimeGate Studios
\FEARXP\MPCustomizations.txt

This file contains a large number of entries that are used to control the
behavior of many game elements, such as:

- Weapon damage, accuracy, and movement penalties
- Armor, medkits, and SlowMo pickups
- Health and armor refill stations
- Initial health and armor values
- Gravity and falling damage
- Movement speeds
- Scoring for all game modes
- Server limits for proximity mines and remotes

For example, the following entry in the MPCustomizations.txt file allows
the damage of the Pistol to be customized:

; Specifies the amount of Instantaneous damage done by this type of ammo.
; Float min=0.0 (Single value)
;Arsenal/Ammo/MultiPlayer/Pistol/InstDamage=25.000000

The first line is a description of the entry.  Next is the type and range 
of the value (if applicable), as well as a specification of whether the 
entry deals with a single value or multiple values.  The last line is the
actual entry itself, which consists of the entry name, an equal sign, and
the default value of the entry.  Note that the last line is preceded by a
semi-colon character, which indicates that it is a comment and will not be
used by the game.  To change this entry, the semi-colon must be removed
from the last line, and the value changed to the new value.  For example,
to increase the pistol damage to 30, the example above would be changed to:

; Specifies the amount of Instantaneous damage done by this type of ammo.
; Float min=0.0 (Single value)
Arsenal/Ammo/MultiPlayer/Pistol/InstDamage=30.000000

It is recommended that an unmodified copy of the MPCustomizations.txt file 
is kept as backup in case it is necessary to start over.  

Once all of the changes are made, save the file and start a hosted or
dedicated server.  The MPCustomizations.txt file will automatically be read 
by the server and applied when it starts.  In addition, clients will see a 
"wrench" icon next to the server in the server browser, which indicates 
that it is using customized values.

It is also possible to specify a customizations file on the command line
when starting the dedicated server using the "-mpcustomizations" switch.
For example, the following command line will start a dedicated server
which will use a customizations file named "MyCustomizations.txt":

fearserverxp.exe -mpcustomizations MyCustomizations.txt

If no path is provided, as in the example above, the server will look for 
the customizations file in the FEAR user directory, as described in the
beginning of this section.  However, the server will also recognize a full 
path in this option if one is specified, for example:

fearserverxp.exe -mpcustomizations c:\fearxp\MyCustomizations.txt

To prevent the server from using a customizations file, specify "none" as
the argument to the -mpcustomizations switch.

NOTE: Customizing a server as described above is an advanced feature that
may not produce the expected results in all situations.  Some values for 
server customizations may result in unexpected gameplay behavior if set 
incorrectly.


VIII. Custom Content
===========================================================================

In addition to the server customizations described in the previous section,
custom content such as maps, sounds, skins, and textures can be created and
added to a F.E.A.R. Extraction Point server.  This type of custom content 
will be automatically downloaded to clients when they connect to the server.

Custom content is installed on the server and delivered to clients as an
"archive". An archive is a packed file created with the F.E.A.R. ArchiveEdit 
tool, and contains a directory structure as well as content files.  F.E.A.R.
Extraction Point runs with multiple archives, which are combined together at 
load time to appear as a single directory structure and set of files.

To use a custom archive on the server, it must be added to the server's
archive configuration file.  By default, the server uses the Default.archcfg
file located in the main installation directory.  To add the archive, edit 
this file and add the name of the archive to the end of the list.  The name 
can include a full or relative path to the location of the archive, or just 
the name if it resides in the main installation directory.

When a game server is started, it will automatically load all of the archives 
specified in its archive configuration file.  If one of these archives 
contains a custom map, for example, that map will then be available for 
selection in the server's map list.

One important feature of F.E.A.R. archives is the concept of archive 
layering. Layering means that any files found by the game in an archive will 
override those files that appear earlier in the list of archives installed 
on the server.  For example, consider an archive that contains a sound file 
named "guns\Snd\Shotgun\fire.wav". This file will hide any files of the same 
name which reside in archives that are loaded prior to this one in the 
server's configuration file.  This provides a convenient mechanism for 
customizing server content by simply "overriding" files that already
exist in the game with new files that share the same name.

Before clients will be able to successfully download content from the 
server, the server's content download settings must be specified.  There are
two forms of supported content transfer in F.E.A.R.:

1) Server native content download.  In this form of content transfer, the 
game server itself transfers the archive files to any connecting clients that 
do not already have the files.

2) HTTP download.  This method of content transfer uses one or more external 
web (HTTP) server URLs to serve content files to connecting clients, and can
usually provide greater transfer speeds than server native content download.
For more information on HTTP servers, please consult the appropriate system 
documentation.

By default, the server does not allow any transfers.  There are two ways to 
change this:

1) Start the F.E.A.R. Extraction Point client, select Multiplayer, click Host, 
then select Custom content.  Change the Allow Content Download setting to Yes, 
and configure download rates as desired.  It is recommended that the download 
rate not exceed 5000-7000 bytes/second.  Note that the higher the allowed 
download rate, the higher the load placed on the server.  If gameplay 
degrades while content transfers are in progress with the server, consider 
lowering the allowed transfer rate.

2) Edit the server options file, which allows configuration of native 
transfers as described above as well as HTTP redirect transfers.  To 
configure HTTP redirects, add the URL of each HTTP server, separated by 
commas, to the "RedirectURLs" option in the ServerSettings section.  Note
that each URL must include the "http://" prefix. The server options file 
resides in the following directory:

C:\Documents and Settings\All Users\Documents\TimeGate Studios
\FEARXP\ServerOptions

To reduce transfer times on files, F.E.A.R. supports compression on both 
the server native transfers and HTTP transfers.  If a server is started
with custom content and is configured to allow native transfers, it will 
store pre-compressed archives which will be used for transfers to connecting
clients.  The server stores the pre-compressed archives in the following 
location:

C:\Documents and Settings\All Users\Documents\TimeGate Studios
\FEARXP\Custom\CompressedArch

HTTP servers can serve compressed content by enabling HTTP Compression. 
Configuring HTTP Compression varies from server to server, so it may be 
necessary to consult the web server's documentation on this feature.  Note 
that HTTP Compression is not required by the F.E.A.R. client, however, as it 
will automatically handle both compressed and uncompressed HTTP transfers.

When a client initially connects to a server, it will receive a list of all 
of the custom archives installed on the server.  It will also receive the 
list of HTTP redirects, if any, and the server's transfer settings.  If the
client is missing any of the server's archives, it will attempt to retrieve 
them first from the HTTP servers, in the order specified by the server,
and then from the server itself if the server allows content transfers.
Note that the client is capable of retrieving any archive from any of the 
available sources - it is not necessary for all of the archives to be 
available from one source.

For example, consider a server that is configured in the following manner:

- 3 custom archives:
 
	- Archive1 (custom maps)
	- Archive2 (custom sounds)
	- Archive3 (custom textures)

- 2 HTTP redirect URLs: 

	- WebServer1 (Archive1)
	- WebServer2 (Archive2)

- Server content download enabled

A client that connects to this server for the first time will need to retrieve
all three of the server's custom archives.  Assuming that the client is 
configured to allow content transfer and HTTP redirects, the following 
sequence of events will occur:

1) The client attempts to retrieve Archive1 from WebServer1.  This succeeds since
WebServer1 has Archive1 available.

2) The client attempts to retrieve Archive2 from WebServer1.  Since WebServer1
does not have this file, the client will move on to WebServer2. WebServer2 does
have Archive2 available, so the client transfers Archive2 from WebServer2.

3) The client attempts to retrieve Archive3 from WebServer1.  WebServer1 does not
have this file, so the client attempts to retrieve it from WebServer2.  This file
is not available on WebServer2, so the client attempts to retrieve it from the
game server itself.  Since the game server has content download enabled, the client
will then proceed to retrieve Archive3 from the game server.

Once the client has successfully retrieved all of the server's custom content, it
will join the game.  Subsequent connections by the same client will not require
any content transfers, assuming that none of the server's archives have changed.
	
The client stores downloaded archives in the following directory:

C:\Documents and Settings\All Users\Documents\TimeGate Studios
\FEARXP\Custom\DownloadedContent.

To quickly remove all custom content from a client machine, simply delete this
directory.  The content will be transferred again as needed when the client
connects to a game server.


IX. Limiting Bandwidth
===========================================================================

F.E.A.R. Extraction Point allows server operators to limit the amount of data that's 
being sent to players on high bandwidth connections. When used correctly, this feature 
can greatly improve performance.

You can adjust your bandwidth limit in the host options screen before launching your
server via the bandwidth or custom bandwidth options.  

The preset values available to you are as follows:

Preset		Max bandwidth
------		-------------
DSL (low) 	128kbps
DSL (High)	256kbps
Cable		256kbps
T1		1500kbps
T3		10000kbps

Note that kbps in the table above stands for kilobits per second.

When you first set up your server, you should set this option to match as closely as
possible with the upstream bandwidth rating of your Internet connection. This
information can be obtained from your ISP. If none of the available options are
suitable for your connection, use the custom bandwidth setting to enter the correct
value. 

Dedicated server operators can fine-tune this setting in the console while the server
is actually running. To do this, just type "BandWidthTargetServer" and the value you
wish to use in the console, and then press <Enter>. Values entered must be in bits
per second, not kilobits per second. For instance, if you wanted to change the
maximum upstream bandwidth to 128kbps, the bandwidthtargetserver variable should
be changed to 128 x 1024, which equals 131072 bits per second.

The final command in the console would then be:

BandWidthTargetServer 131072

NOTE:  It is VERY important that you set this value correctly. Setting the limit
too high may result in very poor performance for players with a high ping. Similarly,
setting it too low may result in choppiness for players with lower ping. You may
want to experiment with different values to find the best setting for your particular
situation.


X. Recommended Player Limits
===========================================================================

The number of players that your server can realistically handle depends on your
connection speed and your machine specs.  Use the table below to determine the
max players you should specify in the host options when setting up your server:

Connection            	Machine Spec			# of Players 
----------------------------------------------------------------------------
56K                  	| Minimum Server (Host)		| 2 (including host) 
DSL (Low)		| Fast Server (Dedicated)	| 4                         
DSL (High)/Cable*      	| Fast Server (Dedicated)	| 4-8                
T1 and above           	| Minimum Server (Dedicated)	| 16              
----------------------------------------------------------------------------

* Dependant on upload speed, Cable and DSL connections vary.

XI. Dedicated Servers and incompatible video cards
===========================================================================

To run a dedicated server on a machine that does not meet the video card
requirements for the full game, just follow these steps:

1) On a machine that DOES meet the full requirements for the game, set up 
all of your levels and options in the host menu and save this configuration with
a name of your choosing. If you wish, you can save off multiple configurations in
this manner. 

2) Copy the configuration file(s) to the dedicated server.

3) When you launch the dedicated server application (FEARServer.exe) directly, 
you will be prompted for the configuration file that you wish to use.

It's that simple! 

The server configuration files can be found in the following folder:

C:\Documents and Settings\All Users\Documents\TimeGate Studios
\FEARXP\ServerOptions

XII. PUNKBUSTER
===============

The Win32 standalone server is configured with PunkBuster disabled by
default.  To enable PunkBuster, specify the following option in the 
[ServerSettings] section of the server options file:

UsePunkBuster=1

XIII. END-USER LICENSE AGREEMENT
================================

YOU SHOULD CAREFULLY READ THE FOLLOWING END USER LICENSE AGREEMENT BEFORE INSTALLING 
THIS SOFTWARE PROGRAM. BY INSTALLING, COPYING, OR OTHERWISE USING THE SOFTWARE PROGRAM, 
YOU AGREE TO BE BOUND BY THE TERMS OF THIS AGREEMENT. IF YOU DO NOT AGREE TO THE TERMS 
OF THIS AGREEMENT, PROMPTLY RETURN THE UNUSED SOFTWARE PROGRAM TO THE PLACE OF 
PURCHASE OR CONTACT SIERRA ENTERTAINMENT CUSTOMER SERVICE AT (800) 757-7707 FOR A FULL 
REFUND OF THE PURCHASE PRICE WITHIN 30 DAYS OF THE ORIGINAL PURCHASE.

This software program and any files that are provided by Sierra Entertainment, Inc., 
to you by on-line transmission or otherwise to 'patch,' 'update,' or modify the 
software program, as well as any printed materials, on-line or electronic 
documentation, and any and all copies and derivative works of such software program 
and materials are the copyrighted work of Sierra Entertainment, Inc. and/or its 
wholly owned subsidiaries, or its licensors or suppliers ("Sierra"). All use of the 
software program (“Program”) is governed by the terms of the End User License 
Agreement which is provided below ("License Agreement"). The Program is solely for 
use by end users according to the terms of the License Agreement. Any use, 
reproduction or redistribution of the Program not in accordance with the terms of the 
License Agreement is expressly prohibited.
	
END USER LICENSE AGREEMENT

1. Limited Use License. Sierra hereby grants, and by installing the Program 
you thereby accept, a limited, non-exclusive license and right to install and use one 
(1) copy of the Program for your use on either a home or portable computer. The 
Program also contains a "Campaign Editor" (the "Editor") that allows you to create 
custom levels or other materials for your personal use in connection with the Program 
("New Materials"). All use of the Editor or any New Materials is subject to this 
License Agreement. In addition, the Program has a multi-player capability that allows 
users to utilize the Program over the Internet via GameSpy.com or another gaming 
network designated by Sierra (an "On-line Provider"). Use of the Program over 
GameSpy.com or other On-line Provider is subject to your acceptance of GameSpy.com's 
or such other On-line Provider's Terms of Use Agreement as may be updated or modified 
at any time. The Program is licensed, not sold. Your license confers no title or 
ownership in the Program.  

2. Ownership. All title, ownership rights and intellectual property rights in 
and to the Program and any and all copies thereof (including but not limited to any 
titles, computer code, themes, objects, characters, character names, stories, dialog, 
catch phrases, locations, concepts, artwork, animations, sounds, musical compositions, 
audio-visual effects, methods of operation, moral rights, any related documentation, 
and "applets" incorporated into the Program) are owned by Sierra or its licensors. 
The Program is protected by the copyright laws of the United States, international 
copyright treaties and conventions, and other laws. All rights are reserved. The 
Program contains certain licensed materials, and Sierra's licensors may protect their 
rights in the event of any violation of this Agreement. The Program may access 
websites owned, controlled by, or operated by licensed affiliates of Sierra, and 
receive patches and/or updates to the Program from these websites. All patches, 
updates or other downloadable material used by, or incorporated into, the Program are 
the copyrighted property of Sierra, who reserves all rights therein, and shall be 
governed by the terms and conditions of this Agreement.

3. Responsibilities of End User.

A. Subject to the Grant of License hereinabove, you may not, in whole or in part, 
copy, photocopy, reproduce, translate, reverse engineer, derive source code from, 
modify, disassemble, decompile, create a source code equivalent of, create derivative 
works based on, or remove any proprietary notices or labels from the Program without 
the prior consent, in writing, of Sierra.

B. The Program is licensed to you as a single product. Its component parts may not be 
separated for use on more than one computer. 

C. You are entitled to use the Program for your own use, but you are not entitled to:

(i) 	sell, grant a security interest in or transfer reproductions of the Program 
to other parties in any way, nor to rent, lease or license the Program to others 
without the prior written consent of Sierra;

(ii) exploit the Program or any of its parts for any commercial purpose, including, 
but not limited to, use at a cyber café, computer gaming center or any other location-
based site (Sierra may offer a separate Site License Agreement to permit you to make 
the Program available for commercial use; contact Sierra for details);

(iii)	use or allow third parties to use the Editor and the New Materials created 
thereby for commercial purposes, including, but not limited to, distribution of New 
Materials on a stand-alone basis or packaged with other software or hardware through 
any and all distribution channels, including, but not limited to, retail sales and 
on-line electronic distribution, without the express written consent of Sierra; 

(iv) host or provide matchmaking services for the Program or emulate or redirect the 
communication protocols used by Sierra in the network feature of the Program, through 
protocol emulation, tunneling, modifying or adding components to the Program, use of 
a utility program or any other techniques now known or hereafter developed, for any 
purpose, including, but not limited to, network play over the Internet, network play 
utilizing commercial or non-commercial gaming networks, or as part of content 
aggregation networks, without the prior written consent of Sierra; and

(v) create or maintain, under any circumstance, more than one simultaneous connection 
to any hosting service utilized for on-line play. All such connections, whether 
created by the Program or by other tools and utilities, may only be made through 
methods and means expressly approved by Sierra. Under no circumstances may you 
connect, or create tools that allow you to connect, to the hosting service's private 
binary interface or interfaces other than those explicitly provided by Sierra for 
public use.
	
4. Program Transfer. You may permanently transfer all of your rights under this 
License Agreement, provided the recipient agrees to the terms of this License 
Agreement and you agree to remove the Program and any New Materials from your home or 
portable computer.
	
5. Termination. This License Agreement is effective until terminated. You may 
terminate the License Agreement at any time by destroying the Program and any New 
Materials. Sierra may, at its discretion, terminate this License Agreement in the 
event that you fail to comply with the terms and conditions contained herein. In such 
event, you must immediately destroy the Program and any New Materials. 
	
6. Export Controls. The Program may not be re-exported, downloaded or otherwise 
exported into (or to a national or resident of) any country to which the U.S. has 
embargoed goods, or to anyone on the U.S. Treasury Department's list of Specially 
Designated Nationals or the U.S. Commerce Department's Table of Denial Orders. By 
installing the Program, you are agreeing to the foregoing and you are representing 
and warranting that you are not located in, under the control of, or a national or 
resident of any such country or on any such list.
	
7. Customer Service/Technical Support. "Customer Service" as used herein may be 
provided to you by Sierra representatives by telephone and/or by electronic message 
(e-mail). "Technical Support" may be provided to you by Sierra by telephone, by 
electronic message (e-mail), or by posting of information related to known technical 
support issues on a website. Unless otherwise stated in the Program's packaging or in 
the Program's user manual, nothing herein shall be construed so as to place a duty 
upon Sierra to provide Customer Service or Technical Support via a toll-free telephone 
number for an unlimited period of time.
	
8. Duration of the "On-Line" Component of the Program. This Program contains an 
"on-line" component that allows you to utilize the Product over the Internet utilizing 
servers and software maintained by Sierra and or its affiliates.  Sierra may, in its 
sole discretion, provide the servers and software technology necessary to utilize the 
"on-line" component of the Program, or Sierra may license to third parties the right 
to provide the servers and software technology necessary to utilize the "on-line" 
component of the Program. However, nothing contained herein shall be construed so as 
to place an obligation upon Sierra to provide the servers and software technology 
necessary to utilize the "on-line" component beyond the time that the Program is Out 
of Publication. The term "Out of Publication" as used herein shall mean that the 
Program is no longer being manufactured by Sierra.
	
9. Limited Warranty. Sierra expressly disclaims any warranty for the Program, Editor 
and Manual(s). The Program, Editor and Manual(s) are provided "as is" without warranty 
of any kind, either express or implied, including, without limitation, the implied 
warranties of merchantability, fitness for a particular purpose, or noninfringement. 
The entire risk arising out of use or performance of the Program and Manual(s) remains 
with the User; however, Sierra warrants up to and including 90 days from the date of 
your purchase of the Program that the media containing the Program shall be free from 
defects in material and workmanship. In the event that the media prove to be defective 
during that time period, and upon presentation to Sierra of proof of purchase of the 
defective Program, Sierra will at its option 1) correct any defect, 2) provide you 
with a product of equal or lesser value, or 3) refund your money. Some states do not 
allow the exclusion or limitation of implied warranties or liability for incidental 
damages, so the above limitations may not apply to you.

10. Limitation of Liability. NEITHER SIERRA ENTERTAINMENT, INC., THE ON-LINE PROVIDER, 
NOR EACH OF THEIR RESPECTIVE PARENTS, SUBSIDIARIES OR AFFILIATES SHALL BE LIABLE IN 
ANY WAY FOR LOSS OR DAMAGE OF ANY KIND RESULTING FROM THE USE OF THE PROGRAM, THE 
EDITOR OR AN AUTHORIZED ON-LINE GAME NETWORK, INCLUDING, BUT NOT LIMITED TO, LOSS OF 
GOODWILL, WORK STOPPAGE, COMPUTER FAILURE OR MALFUNCTION, OR ANY AND ALL OTHER 
COMMERCIAL DAMAGES OR LOSSES. ANY WARRANTY AGAINST INFRINGEMENT THAT MAY BE PROVIDED 
IN SECTION 2-312(3) OF THE UNIFORM COMMERCIAL CODE AND/OR IN ANY OTHER COMPARABLE 
STATE STATUTE IS EXPRESSLY DISCLAIMED. FURTHER, EACH OF SIERRA ENTERTAINMENT, ITS 
PARENT AND THE ON-LINE PROVIDER SHALL NOT BE LIABLE IN ANY WAY FOR THE LOSS OR DAMAGE 
TO PLAYER CHARACTERS, ACCOUNTS, STATISTICS OR USER PROFILE INFORMATION STORED ON AN 
AUTHORIZED ON-LINE GAME NETWORK, INCLUDING GAMESPY.COM. EACH OF SIERRA ENTERTAINMENT, 
ITS PARENT, AND THE ON-LINE PROVIDER SHALL NOT BE RESPONSIBLE FOR ANY INTERRUPTIONS OF 
SERVICE ON GAMESPY.COM OR OTHER AUTHORIZED ON-LINE GAME NETWORK, INCLUDING, BUT NOT 
LIMITED TO, ISP DISRUPTIONS, SOFTWARE OR HARDWARE FAILURES, OR ANY OTHER EVENT WHICH 
MAY RESULT IN A LOSS OF DATA OR DISRUPTION OF SERVICE. Some states do not allow the 
exclusion or limitation of incidental or consequential damages, or allow limitations 
on how long an implied warranty lasts, so the above limitations may not apply.

11. Equitable Remedies. You hereby agree that Sierra would be irreparably damaged if 
the terms of this License Agreement were not specifically enforced, and therefore you 
agree that Sierra shall be entitled, without bond, other security, or proof of 
damages, to appropriate equitable remedies with respect to breaches of this License 
Agreement, in addition to such other remedies as Sierra may otherwise have available 
to it under applicable laws. In the event any litigation is brought by either party 
in connection with this License Agreement, the prevailing party in such litigation 
shall be entitled to recover from the other party all the costs, attorneys' fees and 
other expenses incurred by such prevailing party in the litigation.

12. Limitations on License. Nothing in this License Agreement shall preclude you from 
making or authorizing the making of another copy or adaptation of the Program, 
provided, however, that (1) such new copy or adaptation is created as an essential 
step in your utilization of the Program in accordance with the terms of this License 
Agreement and for NO OTHER PURPOSE; or (2) such new copy or adaptation is for archival 
purposes ONLY and all archival copies are destroyed in the event of your Transfer of 
the Program, the Termination of this Agreement or other circumstances under which 
your continued use of the Program ceases to be rightful. 

13. Miscellaneous. This License Agreement shall be deemed to have been made and 
executed in the State of California, and any dispute arising hereunder shall be 
resolved in accordance with the law of California. You agree that any claim asserted 
in any legal proceeding by one of the parties against the other shall be commenced 
and maintained in any state or federal court located in the State of California, 
County of Los Angeles, having subject matter jurisdiction with respect to the dispute 
between the parties. This License Agreement may be amended, altered or modified only 
by an instrument in writing, specifying such amendment, alteration or modification, 
executed by both parties. In the event that any provision of this License Agreement 
shall be held by a court or other tribunal of competent jurisdiction to be 
unenforceable, such provision will be enforced to the maximum extent permissible, and 
the remaining portions of this License Agreement shall remain in full force and 
effect. This License Agreement constitutes and contains the entire agreement between 
the parties with respect to the subject matter hereof and supersedes any prior oral 
or written agreements.

You hereby acknowledge that you have read and understand the foregoing License 
Agreement and agree that the action of installing the Program is an acknowledgment of 
my agreement to be bound by the terms and conditions of the License Agreement 
contained herein. You also acknowledge and agree that this License Agreement is the 
complete and exclusive statement of the agreement between Sierra and yourself and 
that the License Agreement supersedes any prior or contemporaneous agreement, either 
oral or written, and any other communications between you and Sierra.

----------------------------------------------------------------------------

(C)2006 Monolith Productions, Inc. All rights reserved.

Published by Vivendi Games, Inc. under license from Monolith Productions, Inc.

F.E.A.R., Vivendi Games and the Vivendi Games logo are trademarks of Vivendi 
Games, Inc.

Sierra and the Sierra logo are registered trademarks or trademarks of Sierra 
Entertainment, Inc. in the U.S. and/or other countries.

MONOLITH and the MONOLITH LOGO TM & © Warner Bros. Entertainment Inc.

Developed by TimeGate Studios, Inc.

TimeGate and the TimeGate logo are trademarks of TimeGate Studios, Inc.

This product contains software technology licensed from GameSpy Industries, 
Inc. (C) 1999-2006 GameSpy Industries, Inc. 

GameSpy and the "Powered by GameSpy" design are trademarks of GameSpy 
Industries, Inc. All rights reserved. 

NVIDIA, the NVIDIA Logo, GeForce and "The Way It's Meant to be Played" Logo 
are registered trademarks and/or trademarks of NVIDIA Corporation in the 
United States and other countries.

Uses Havok(TM); (C)Copyright 1999-2002 Havok.com Inc. (and its Licensors). All
Rights Reserved. See www.havok.com for details.

MPEG Layer-3 audio coding technology licensed from Fraunhofer IIS and Thomson
Multimedia

Uses Bink Video. Copyright (C)1997-2006 by RAD Game Tools, Inc.

Windows(R) and DirectX are trademarks or registered trademarks of Microsoft
Corporation in the United States and other countries.

Pentium(R) is a registered trademark of Intel Corporation in the United States
and other countries.

The ratings icon is a registered trademark of the Entertainment Software
Association.

TerraServer images courtesy of the USGS.

All other copyrights and trademarks are the property of their respective owners.
All rights reserved.

(s05)