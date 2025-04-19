FROM debian:12-slim

ARG  KUBECTL_VERSION
ENV  KUBECTL_VERSION=${KUBECTL_VERSION}

# 1. Tiny runtime utilities
RUN apt-get update -qq \
 && apt-get install -y --no-install-recommends bash curl file ca-certificates \
 && rm -rf /var/lib/apt/lists/*

# 2. Download kubectl, auto‑decompress if gzip, confirm it’s amd64 ELF
#    (run through bash so we can use pipefail)
RUN bash -euxo pipefail -c '\
    curl -fsSL -o /usr/local/bin/kubectl.tmp \
         "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl"; \
    if file /usr/local/bin/kubectl.tmp | grep -q "gzip compressed"; then \
        gunzip -c /usr/local/bin/kubectl.tmp > /usr/local/bin/kubectl; \
    else \
        mv /usr/local/bin/kubectl.tmp /usr/local/bin/kubectl; \
    fi; \
    file /usr/local/bin/kubectl | grep -q "ELF 64-bit LSB executable, x86-64"; \
    chmod +x /usr/local/bin/kubectl \
'

ENTRYPOINT ["/bin/bash"]
