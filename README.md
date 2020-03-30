# Images for Apache Qpid Proton and Electron

Apache Qpid Proton Messaging toolkit and Electron built into container images.

Shell script `build-image.sh` will create:

- `qpid-proton:0.30.0` Qpid Proton base image with libraruy installed in `/qpid-proton/`
- `electron-client-server:0.30.0` Qpid Electron client-server built on `qpid-proton`
