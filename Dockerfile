FROM alpine
ADD . /test
RUN mkdir -p /build
CMD ["cp", "-r", "/test/", "/build/"]