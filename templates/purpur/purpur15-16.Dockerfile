FROM gcr.io/distroless/java:8 AS builder
WORKDIR /build

ADD https://api.purpurmc.org/v2/purpur/{{MINECRAFT_VERSION}}/latest/download purpur.jar
RUN ["/usr/bin/java", "-DPurpur.IReallyDontWantSpark=true", "-jar", "purpur.jar"]


FROM gcr.io/distroless/java:8

WORKDIR /data
COPY --from=builder /build/purpur.jar purpur.jar
COPY --from=builder /build/cache/ cache/
ADD eula.txt eula.txt

ENTRYPOINT ["/usr/bin/java", "-DPurpur.IReallyDontWantSpark=true", "-jar", "purpur.jar"]