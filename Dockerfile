# ──────────────────────────────────────────────────────────────────────────────
# Debian‑based “kubectl + curl + bash” image.
# Pass KUBECTL_VERSION (e.g. v1.30.1) at build time.
# ──────────────────────────────────────────────────────────────────────────────
FROM debian:12-slim

ARG  KUBECTL_VERSION
ENV  KUBECTL_VERSION=${KUBECTL_VERSION}

# Minimal user‑land: bash, curl, and CA certs
RUN apt-get update -qq \
 && apt-get install -y --no-install-recommends bash curl ca-certificates gnupg \
 && rm -rf /var/lib/apt/lists/*

# Fetch the exact kubectl version requested
RUN curl -fsSL --fail -o /usr/local/bin/kubectl \
      "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl" \
 && chmod +x /usr/local/bin/kubectl

ENTRYPOINT ["/bin/bash"]
