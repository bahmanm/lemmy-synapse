<h1 style="vertical-align: center"><img src="doc/img/lemmy-synapse-logo.png" style="width: 96px;"/> lemmy-synapse </h1>

A humble bundle of observability and monitoring for your Lemmy cluster.

# 1. What is this?

If you're an admin, you know how important it is to be able to check the various details
of your instance in a glance.  That is especially important when troubleshooting an outage
or a drop in latency.

Even after the outage, you'd want to peruse the system statistics prior to the outage and
during it and understand what was the root cause.

One of the standard ways in the industry to achieve that is to install an observability
stack in your cluster that scrapes yours hosts and services for useful information, stores
them and allows you to query them in various ways.

lemmy-synapse is an attempt to bring that fresh breeze of observability to your instance
with ease.

Once installed, you'd have access to the power of Prometheus and Grafana to massage and
visualise your instance stats the way you need it.

Additionally, you'd have access to a small number of pre-configured dashboards which you
can start using right away.

📸 Here are a couple of screenshots for your browsing pleasure:

* [PostgreSQL dashboard](doc/img/pg-stats.png)
* [Host dashboard](doc/img/host-stats.png)
* [Docker dashboard](doc/img/docker-stats.png)

# 2. Installation

Great!  You have decided to give lemmy-synapse a shot.  There are only a couple of
prerequisites and things you should figure out in advance.

## 2.1 Prerequisites

### 2.1.1 SSH Access

Needless to say, you must have SSH access to your server.

### 2.1.2 PostgreSQL Access

To be able to setup lemmy-synapse, your instance PostgreSQL must be accessible from
outside the Docker network.

One simple way to test it out is to run the following command on your server.

```text
psql -U lemmy -d lemmy -h localhost
```

If you see a password prompt, you're good to go.

---

For reason beyond lemmy-synapse, Lemmy's installation repo (aka lemmy-ansible) does not
expose PG ports to outside of Docker network.  Doing so is easy and only requires
modifying `docker-compose.yml`, so that the `postgres` block looks like this:

```yaml
...
  postgres:
    image: docker.io/postgres:15-alpine
    hostname: postgres
    environment:
      - POSTGRES_USER=lemmy
      - POSTGRES_PASSWORD=...
      - POSTGRES_DB=lemmy
    ports:
      - "5432:5432"
    volumes:
      - ./volumes/postgres:/var/lib/postgresql/data:Z
      - ./customPostgresql.conf:/etc/postgresql.conf
    restart: always
    command: postgres -c config_file=/etc/postgresql.conf
    logging: *default-logging
...    
```

### 2.1.3 bmakelib

[bmakelib](https://github.com/bahmanm/bmakelib) is a library that I wrote and maintain to
help me write cleaner make files (yes, I'm a big fan of GNU Make 😁).

Please follow the [installation steps](https://github.com/bahmanm/bmakelib#how-to-install)
to, well, install it.

## 2.2 What You Need To Know

### 2.2.1 Docker Network 

In order to scrape metrics, lemmy-synapse will attach to your instance's Docker network
and probe its services (namely PostgreSQL.)

To find out the name, you can try the following command:

```text
docker network ls | perl -nalE 'say $F[1] if $F[1] =~ /(lemmy|_default)/'
```

### 2.2.2 PostgreSQL Password

lemmy-synapse creates a special PostgreSQL user with very limited permissions.  In order
to do that you'd need to know the password to the PG admin user (which is `lemmy` unless
you have manually configured your PG server.)

To find out the password you can run the following command:

```text
hjson-cli -c lemmy.hjson | jq -r '.database.password'
```

## 2.3 Review and Edit The Configuration

The last step is to review the information in `installation-config.yml` and fill in the
blanks. 

## 2.4 Install It Already!

Installing lemmy-synapse is, hopefully, just a one-liner:

```text
make ansible.lemmy-synapse-server=<YOUR_INSTANCE> install
```

# 3. How To Use

Once the installation is done, Grafana (which is the metrics visualisation and reporting
tool) should be running and ready to accept connections on port `3000`.

One simple and secure way to access it is via SSH port forwarding.  For example, assuming
you've run the following command, you can access Grafana at http://localhost:3000 with
user `admin` and password `admin`.

```text
ssh -L3000:localhost:3000 <YOUR_INSTANCE>
```

Happy monitoring!
