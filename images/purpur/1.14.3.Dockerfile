FROM gcr.io/distroless/java:8
WORKDIR /data

ADD https://api.purpurmc.org/v2/purpur/1.14.3/latest/download purpur.jar
ENTRYPOINT ["/usr/bin/java", "-DPurpur.IReallyDontWantSpark=true", "-jar", "purpur.jar"]