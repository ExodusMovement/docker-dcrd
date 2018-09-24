FROM ubuntu:18.04 as builder

ENV BUILD_TAG 1.3.0

# create user
ENV TERM linux
ENV USER decred
ENV HOME /home/$USER
ENV DOTDCRD $HOME/.dcrd
RUN adduser --disabled-password --gecos '' $USER

RUN apt update
RUN apt install -qy \
    curl

RUN set -x && \
    # Decred release url and files
    DCR_RELEASE_URL="https://github.com/decred/decred-binaries/releases/download/v$BUILD_TAG" && \
    DCR_MANIFEST_FILE="manifest-v$BUILD_TAG.txt" && \
    DCR_RELEASE_NAME="decred-linux-amd64-v$BUILD_TAG" && \
    DCR_RELEASE_FILE="$DCR_RELEASE_NAME.tar.gz" && \

    # Download archives
    cd /tmp && \
    curl -SLO $DCR_RELEASE_URL/$DCR_RELEASE_FILE && \
    curl -SLO $DCR_RELEASE_URL/$DCR_MANIFEST_FILE && \
    curl -SLO $DCR_RELEASE_URL/$DCR_MANIFEST_FILE.asc && \

    # Extract and install
    tar xvzf $DCR_RELEASE_FILE && \
    mv $DCR_RELEASE_NAME/dcrd $HOME && \
    mkdir -p $DOTDCRD && \
    chown -R $USER.$USER $HOME

FROM ubuntu:18.04

RUN groupadd --gid 1000 decred \
  && useradd --uid 1000 --gid decred --shell /bin/bash --create-home decred

COPY --from=builder /home/decred/dcrd /usr/local/bin/

# switch user for runtime
USER decred
WORKDIR /home/decred

# PEER & RPC PORTS
EXPOSE 9108 9109

ENV \
  DCRD_BIND=0.0.0.0 \
  DCRD_PORT=9108 \
  DCRD_RPC_BIND=0.0.0.0 \
  DCRD_RPC_PORT=9109 \
  DCRD_ARGUMENTS=""

CMD exec dcrd \
  --listen=$DCRD_BIND:$DCRD_PORT \
  --rpclisten=$DCRD_RPC_BIND:$DCRD_RPC_PORT \
  $DCRD_ARGUMENTS
