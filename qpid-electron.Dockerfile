FROM qpid-proton:0.30.0 AS electron-example

WORKDIR /go/src/proton-verify
COPY electron-client-server.go .
RUN apt-get install -y golang git
ENV GOBIN=/go/bin
RUN go get qpid.apache.org/amqp \
    && go get qpid.apache.org/electron
RUN go install electron-client-server.go


FROM qpid-proton:0.30.0 AS app
COPY --from=electron-example /go/bin/electron-client-server /app/electron-client-server
ENTRYPOINT [ "/app/electron-client-server" ]