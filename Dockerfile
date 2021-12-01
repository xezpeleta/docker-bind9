FROM ubuntu:focal

ENV TZ UTC

RUN set -eux; \
# installation
	apt-get update; \
	DEBIAN_FRONTEND=noninteractive apt-get full-upgrade -y; \
	DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
		bind9 \
		bind9-utils \
		tzdata \
		; \
	DEBIAN_FRONTEND=noninteractive apt-get remove --purge --auto-remove -y; \
	rm -rf /var/lib/apt/lists/*; \
# smoke test
	named -v; \
# create manifest
	mkdir -p /usr/share/rocks; \
	(echo "# os-release" && cat /etc/os-release && echo "# dpkg-query" && dpkg-query -f '${db:Status-Abbrev},${binary:Package},${Version},${source:Package},${Source:Version}\n' -W) > /usr/share/rocks/dpkg.query

USER bind
VOLUME ["/var/cache/bind", "/var/lib/bind"]

EXPOSE 53

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]
