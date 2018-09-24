# docker-dcrd

Decred: [https://github.com/decred/dcrd](https://github.com/decred/dcrd)

Image location: [https://quay.io/repository/exodusmovement/dcrd](https://quay.io/repository/exodusmovement/dcrd)

Every new dcrd release have own branch where branch name is dcrd version. For each docker image release we create tag `BRANCH_NAME-xxx`, where `xxx` is release version for *current* branch. Docker image with latest tag is used only for development and contain last build (please do not use it for production!).

Branches and releases:

 - [1.3.0](https://github.com/ExodusMovement/docker-dcrd/tree/1.3.0)
   - [1.3.0-001](https://github.com/ExodusMovement/docker-dcrd/tree/1.3.0-001)

## Usage

### Build the image

> docker build -t dcrd .

### Run example

> docker run -v /mnt/SSD-EVO/dcrd-main:/data -e "DCRD_ARGUMENTS=--datadir=/data" dcrd
