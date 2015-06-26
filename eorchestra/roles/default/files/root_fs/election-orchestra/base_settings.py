# debug, set to false on production deployment
DEBUG = False

ROOT_URL = 'https://AGORAENV_HOST/api/queues'

# URL to our HTTP server
VFORK_SERVER_URL = 'http://AGORAENV_HOST'

VFORK_SERVER_PORT_RANGE = [4081, 4083]

# Socket address given as <hostname>:<port> to our hint server.
# A hint server is a simple UDP server that reduces latency and
# traffic on the HTTP servers.
VFORK_HINT_SERVER_SOCKET = 'AGORAENV_HOST'

VFORK_HINT_SERVER_PORT_RANGE = [8081, 8083]

import os
ROOT_PATH = os.path.split(os.path.abspath(__file__))[0]

# SQLALCHEMY_DATABASE_URI = 'sqlite:///%s/db.sqlite' % ROOT_PATH
SQLALCHEMY_DATABASE_URI = 'postgresql+psycopg2:///eorchestra'

PRIVATE_DATA_PATH = os.path.join(ROOT_PATH, 'datastore/private')
PUBLIC_DATA_PATH = '/srv/election-orchestra/server1/public'
PUBLIC_DATA_BASE_URL = 'https://AGORAENV_host:AGORAENV_port/public_data'

# security configuration
SSL_CERT_PATH = '/srv/certs/selfsigned/cert.pem'
SSL_KEY_PATH = '/srv/certs/selfsigned/key-nopass.pem'
ALLOW_ONLY_SSL_CONNECTIONS = True
AUTOACCEPT_REQUESTS = True

KILL_ALL_VFORK_BEFORE_START_NEW = True

QUEUES_OPTIONS = {
    'vfork_queue': {
        'max_threads': 1,
    }
}
