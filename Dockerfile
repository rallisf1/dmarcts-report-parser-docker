FROM alpine:3.20

ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8
ENV PERL5LIB=/usr/local/lib/perl5
ENV PATH=/usr/local/bin:$PATH

RUN apk add --no-cache --update \
gcc g++ make patch perl perl-dev curl wget \
perl unzip tar \
perl-mail-imapclient \
perl-io-socket-inet6 \
perl-io-gzip \
perl-dbd-mysql \
perl-dbd-pg \
perl-file-mimeinfo \
perl-mime-tools \
perl-xml-simple \
perl-io-socket-ssl \
perl-io-socket-ip

RUN curl -L https://cpanmin.us | perl - App::cpanminus

RUN cpanm Mail::Mbox::MessageParser::Perl

WORKDIR /

RUN wget -O /dbx_mysql.pl https://raw.githubusercontent.com/techsneeze/dmarcts-report-parser/refs/heads/master/dbx_mysql.pl
RUN wget -O /dbx_Pg.pl https://raw.githubusercontent.com/techsneeze/dmarcts-report-parser/refs/heads/master/dbx_mysql.pl
RUN wget -O /dmarcts-report-parser.pl https://raw.githubusercontent.com/techsneeze/dmarcts-report-parser/refs/heads/master/dmarcts-report-parser.pl

COPY entry.sh .

RUN chmod +x /dmarcts-report-parser.pl
RUN chmod +x /entry.sh

CMD ["/entry.sh"]