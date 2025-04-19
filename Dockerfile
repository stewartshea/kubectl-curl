# ──────────────────────────────────────────────────────────────────────────────
# Debian‑based kubectl + curl image (auto‑handles gzip‑wrapped binaries)
# ──────────────────────────────────────────────────────────────────────────────
FROM debian:12-slim

ARG KUBECTL_VERSION
ENV KUBECTL_VERSION=${KUBECTL_VERSION}

RUN apt-get update -qq \
 && apt-get install -y --no-install-recommends bash curl ca-certificates file \
 && rm -rf /var/lib/apt/lists/*

# Download, auto‑decompress if needed, verify it really is amd64 ELF
RUN set -euo pipefail ; \
    curl -fsSL -o /usr/local/bin/kubectl.tmp \
      "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl" ;\
    if file /usr/local/bin/kubectl.tmp | grep -q 'gzip compressed'; then \
        gunzip -c /usr/local/bin/kubectl.tmp > /usr/local/bin/kubectl ;\
    else \
        mv /usr/local/bin/kubectl.tmp /usr/local/bin/kubectl ;\
    fi ;\
    file /usr/local/bin/kubectl | grep -q 'ELF 64-bit LSB executable, x86-64' ;\
    chmod +x /usr/local/bin/kubectl

ENTRYPOINT ["/bin/bash"]
