# Use an official Ubuntu base image (you can use another Debian/Ubuntu base if preferred)
FROM ubuntu:22.04

# Prevent interactive prompts during package install
ENV DEBIAN_FRONTEND=noninteractive

# Update and install dependencies, add repos, install azure-cli and terraform
RUN apt-get update && apt-get install -y \
    curl \
    apt-transport-https \
    lsb-release \
    gnupg \
    software-properties-common \
  && curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg \
  && install -o root -g root -m 644 microsoft.gpg /usr/share/keyrings/microsoft.gpg \
  && echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/azure-cli/ $(lsb_release -cs) main" > /etc/apt/sources.list.d/azure-cli.list \
  && curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor > hashicorp.gpg \
  && install -o root -g root -m 644 hashicorp.gpg /usr/share/keyrings/hashicorp.gpg \
  && echo "deb [signed-by=/usr/share/keyrings/hashicorp.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" > /etc/apt/sources.list.d/hashicorp.list \
  && apt-get update && apt-get install -y azure-cli terraform \
  && rm -rf /var/lib/apt/lists/* microsoft.gpg hashicorp.gpg

# Set default shell to bash
CMD [ "bash" ]
