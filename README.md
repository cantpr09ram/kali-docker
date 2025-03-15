# Kail Docker
Kali Docker is a ready-to-use Docker image based on [Kali Linux Rolling](https://www.kali.org/) that comes preconfigured with an XFCE desktop environment, VNC server, and noVNC for browser-based remote desktop access. This project is ideal for security professionals, penetration testers, and anyone who needs a portable Kali environment with most tools available out-of-the-box.

## Features

- **Kali Linux Rolling:** Leverages the latest updates and tools from the official Kali repository.
- **XFCE Desktop Environment:** Lightweight and user-friendly desktop for everyday use.
- **VNC Server:** Allows remote graphical access via VNC clients.
- **noVNC:** Provides browser-based access to your desktop through a secure HTTPS connection.
- **Preinstalled Tools:** Comes with many essential Kali tools (including the option to install a full Kali toolset).
- **Customizable:** Easily extendable with your own packages and scripts.

## Prerequisites

- [Docker](https://docs.docker.com/get-docker/) installed on your system.
- (Optional) [OrbStack](https://orbstack.dev/) or another container engine if using a specialized environment.

## Building the Image
Clone this repository and build the Docker image using the provided Dockerfile:

```bash
git clone https://github.com/yourusername/mykali-docker.git
cd mykali-docker
docker build -t mykali .
```
Running the Container
To start the container in detached mode with privileged access and specific port mappings, run:

```bash
docker run -d --privileged --name mykali -p 9020:8080 -p 9021:5900 mykali
9020:8080: Maps host port 9020 (for noVNC) to container port 8080.
9021:5900: Maps host port 9021 (for VNC) to container port 5900.
```
After the container is running, open your browser and navigate to:

```bash
https://localhost:9020/vnc.html
```
> [!NOTE]  
> Since noVNC uses a self-signed SSL certificate, you may need to add a security exception in your browser.

## Using the Container
- Access via noVNC: Open the URL above to use the remote desktop in your browser.
- Access via VNC Client: Connect using your favorite VNC client to localhost:9021.
- Managing the Container:
  - Stop the container: docker stop mykali
  - Start the container: docker start mykali
  - Remove the container: docker rm mykali (after stopping it)
