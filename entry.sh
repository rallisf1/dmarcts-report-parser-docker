#!/bin/sh

# environment variables
MISSING_VARIABLES=0

if [ -z "$DB_PASS" ]; then
  echo "Error: The environment variable DB_PASS is mandatory and must be set."
  MISSING_VARIABLES=1
fi

if [ -z "$IMAP_HOST" ]; then
  echo "Error: The environment variable IMAP_HOST is mandatory and must be set."
  MISSING_VARIABLES=1
fi

if [ -z "$IMAP_USER" ]; then
  echo "Error: The environment variable IMAP_USER is mandatory and must be set."
  MISSING_VARIABLES=1
fi

if [ -z "$IMAP_PASS" ]; then
  echo "Error: The environment variable IMAP_PASS is mandatory and must be set."
  MISSING_VARIABLES=1
fi

if [ $MISSING_VARIABLES -eq 1 ]; then
  echo "Exiting..."
  exit 1
fi

DEBUG="${DEBUG:-"0"}"
DELETE="${DELETE:-"0"}"
DB_TYPE="${DB_TYPE:-mysql}"
DB_NAME="${DB_NAME:-dmarc}"
DB_USER="${DB_USER:-dmarc}"
DB_HOST="${DB_HOST:-mysql}"
DB_PORT="${DB_PORT:-"3306"}"
IMAP_PORT="${IMAP_PORT:-"993"}"
IMAP_SSL="${IMAP_SSL:-"1"}"
IMAP_TLS="${IMAP_TLS:-"0"}"
TLS_VERIFY="${TLS_VERIFY:-"0"}"
IMAP_IGNORE_ERROR="${IMAP_IGNORE_ERROR:-"0"}"
IMAP_READ_FOLDER="${IMAP_READ_FOLDER:-INBOX}"
IMAP_MOVE_FOLDER="${IMAP_MOVE_FOLDER:-processed}"
MAX_SIZE_XML="${MAX_SIZE_XML:-"50000"}"
COMPRESS_XML="${COMPRESS_XML:-"0"}"
IMAP_MOVE_FOLDER_ERR="${IMAP_MOVE_FOLDER_ERR:-error}"
DELETE_FAILED="${DELETE_FAILED:-"0"}"
# edit config
echo "\$debug = $DEBUG;" > /dmarcts-report-parser.conf
echo "\$delete_reports = $DELETE;" >> /dmarcts-report-parser.conf
echo "\$dbtype = '$DB_TYPE';" >> /dmarcts-report-parser.conf
echo "\$dbname = '$DB_NAME';" >> /dmarcts-report-parser.conf
echo "\$dbuser = '$DB_USER';" >> /dmarcts-report-parser.conf
echo "\$dbpass = '$DB_PASS';" >> /dmarcts-report-parser.conf
echo "\$dbhost = '$DB_HOST';" >> /dmarcts-report-parser.conf
echo "\$dbport = '$DB_PORT';" >> /dmarcts-report-parser.conf
echo "\$imapserver = '$IMAP_HOST';" >> /dmarcts-report-parser.conf
echo "\$imapuser = '$IMAP_USER';" >> /dmarcts-report-parser.conf
echo "\$imappass = '$IMAP_PASS';" >> /dmarcts-report-parser.conf
echo "\$imapport = '$IMAP_PORT';" >> /dmarcts-report-parser.conf
echo "\$imapssl = '$IMAP_SSL';" >> /dmarcts-report-parser.conf
echo "\$imaptls = '$IMAP_TLS';" >> /dmarcts-report-parser.conf
echo "\$tlsverify = '$TLS_VERIFY';" >> /dmarcts-report-parser.conf
echo "\$imapignoreerror = '$IMAP_IGNORE_ERROR';" >> /dmarcts-report-parser.conf
echo "\$imapreadfolder = '$IMAP_READ_FOLDER';" >> /dmarcts-report-parser.conf
echo "\$imapmovefolder = '$IMAP_MOVE_FOLDER';" >> /dmarcts-report-parser.conf
echo "\$imapmovefoldererr = '$IMAP_MOVE_FOLDER_ERR';" >> /dmarcts-report-parser.conf
echo "\$maxsize_xml = $MAX_SIZE_XML;" >> /dmarcts-report-parser.conf
echo "\$compress_xml = $COMPRESS_XML;" >> /dmarcts-report-parser.conf
echo "\$delete_failed = $DELETE_FAILED;" >> /dmarcts-report-parser.conf

echo 'Configuration complete. Ready...'

tail -f /dev/null