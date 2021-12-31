Streamlabs OBS (SLOBS) Websocket Forwarder for Streamdeck
=========================================================


## What is it

It is well documented that Streamlabs OBS exposes an authenticated websocket API for remote control. However, there is also an __un-authenticated__ "local-only" websocket listening on `localhost:28194` of the machine that SLOBS is running. This interface allows any application that is running on the same computer as the SLOBS to control it with no restriction. This project contains a set of utilities that allow you to forward this socket to a remote computer so that software that likes to control SLOBS with this websocket can still happily do it from a remote machine without having to support the "authenticated" remote API. (I'm looking at you StreamDeck)


## How it works

![](./docs/howitworks.drawio.svg)

## Are there any less-jank solutions?

Yes.

* One could probably pester Corsair (Streamdeck developers) to add the remote functionality to the SLOBS plugin that comes with it.
* One could write their own remote SLOBS plugin that replicates all the functionality of the Streamdeck's built-in plugin.
* One could potentially write a websocket proxy that connects to the authenticated SLOBS websocket and expose it in the local machine as an unauthenticated endpoint.

## Installation


On both the host and the remote machines, download the files in the repository and place them in a permanant location. The helper scripts will install the tunnel software with correct configuration and configure them to run automatically as windows services.

### Host

This is the machine that will be running SLOBS.

Since we are exposing the streamdeck unauthenticated API over the network, it's always a good idea to make sure that only specified IPs can connect to it. If you don't care about security you can ignore the following steps and directly run the intall bat.

* Open the `install_host.bat` in your favorite text editor. 
* Find the line `set remoteIp=` and add your "client" (the machine wihch the streamdeck will be connected to) IP there.
* Save the file.

Now, to install the service that will expose the streamlabs port, right click on `install_host.bat` and select `Run as Administrator`


### Client

This is the machine that has the streamdeck software running.

* Open the `install_remote.bat` in your favorite text editor.
* Find the line `set slobsHost=` and specify the IP of the host (the machine that runs SLOBS).
* Save the file.

Install the service by right clicking on `install_remote.bat` and selecting `Run as Administrator`s


## Uninstallation

To remove the services that was installed simply run the corresponding `delete_*.bat`  scripts as administrator.


# Acknowledgements

This project uses few opensource softwares.

- nssm (https://nssm.cc/)
- tcptunnel (https://github.com/vakuum/tcptunnel)