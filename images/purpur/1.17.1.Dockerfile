FROM gcr.io/distroless/java17-debian12:latest AS builder
WORKDIR /build

ADD https://api.purpurmc.org/v2/purpur/1.17.1/latest/download purpur.jar
RUN ["/usr/bin/java", "-DPurpur.IReallyDontWantSpark=true", "-jar", "purpur.jar"]


FROM gcr.io/distroless/java17-debian12:latest
WORKDIR /data
COPY --from=builder /build/purpur.jar purpur.jar
COPY --from=builder /build/cache/ cache/

ENTRYPOINT ["/usr/bin/java", "-DPurpur.IReallyDontWantSpark=true", "-jar", "purpur.jar"]