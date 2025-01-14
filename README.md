# dmarcts-report-parser-docker

Dockerized [techsneeze/dmarcts-report-parser](https://github.com/techsneeze/dmarcts-report-parser)

Supports both mysql and postgresql databases.

## Environment Variables

All [original settings](https://github.com/techsneeze/dmarcts-report-parser/blob/master/dmarcts-report-parser.conf.sample) are configurable via environment variables:

| Variable             | Default value | Required           | Description                                                              |
|----------------------|---------------|--------------------|--------------------------------------------------------------------------|
| DEBUG                | 0             | :x:                | Show debug information on the console                                    |
| DELETE               | 0             | :x:                | Delete the processed reports from their source                           |
| DB_TYPE              | mysql         | :x:                | mysql OR Pg                                                              |
| DB_NAME              | dmarc         | :x:                | Database name                                                            |
| DB_USER              | dmarc         | :x:                | Database username                                                        |
| DB_PASS              |               | :white_check_mark: | Database password                                                        |
| DB_HOST              | mysql         | :x:                | Database hostname                                                        |
| DB_PORT              | 3306          | :x:                | Database port                                                            |
| IMAP_HOST            |               | :white_check_mark: | IMAP server hostname                                                     |
| IMAP_USER            |               | :white_check_mark: | IMAP server username                                                     |
| IMAP_PASS            |               | :white_check_mark: | IMAP server password                                                     |
| IMAP_PORT            | 993           | :x:                | Usually 143 for non-SSL, and 993 for SSL                                 |
| IMAP_SSL             | 1             | :x:                | Use SSL to connect to IMAP                                               |
| IMAP_TLS             | 0             | :x:                | Use StartTLS to connect to IMAP                                          |
| TLS_VERIFY           | 0             | :x:                | Verify the SSL certificate against the IMAP hostname                     |
| IMAP_IGNORE_ERROR    | 0             | :x:                | Ignore some IMAP errors, useful for Exchange                             |
| IMAP_READ_FOLDER     | INBOX         | :x:                | The mailbox directory that holds the DMARC reports                       |
| IMAP_MOVE_FOLDER     | processed     | :x:                | The mailbox directory to move the processed reports                      |
| MAX_SIZE_XML         | 50000         | :x:                | Size in bytes over which the XML raw data won't be saved in the database |
| COMPRESS_XML         | 0             | :x:                | Stores the raw XML data in base64 encoded gzip format                    |
| IMAP_MOVE_FOLDER_ERR | error         | :x:                | The mailbox directory to move the erroneous emails                       |
| DELETE_FAILED        | 0             | :x:                | Delete erroneous emails instead of moving them                           |

I made IMAP credentials required, but that doesn't mean you absolutely need to use this with an IMAP account. You can always bind a volume with zip/xml reports and use this image to scan those.

I also took the liberτy to change the default IMAP settings to match industry standards.

Made this to use it with [mailcow](https://github.com/mailcow/mailcow-dockerized) in my [custom status web app](https://github.com/rallisf1/mailcow-status-app)

## Usage

### Ofelia with compose (suggested)

```yaml
version: "3"
services:
  ofelia:
    image: mcuadros/ofelia:latest
    command: daemon --docker
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro

  dmarc:
    image: rallisf1/dmarcts-report-parser-docker:latest
    labels:
      ofelia.enabled: "true"
      ofelia.job-exec.download-dmarc.schedule: "@every 6h"
      ofelia.job-exec.download-dmarc.command: "/dmarcts-report-parser.pl -i"
```

### Cron on host

```sh
crontab -e

0 */6 * * * docker exec -it YOUR_CONTAINER_NAME /dmarcts-report-parser.pl -i >> /var/logs/dmarcts-report-parser.log 2>&1
```

__Notice: this is just an example with logging on the host. Do not use this without log rotation, especially when enabling DEBUG__

## License

This repo and the resulting docker image: MIT

The original [techsneeze/dmarcts-report-parser](https://github.com/techsneeze/dmarcts-report-parser) project: GPLv3
