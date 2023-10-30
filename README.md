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

lemmy-synapse is an attemp to bring that fresh breeze of observability to your instance
with ease.

Once installed, you'd have access to the power of Prometheus and Grafana to massage and
visualise your instance stats the way you need it.

Additionally, you'd have access to a small number of preconfigured dashboards which you
can start using right away.

Here are a couple of screenshots for your browsing pleasure:

* [PostgreSQL dashboard](doc/img/pg-stats.png)
* [Host dashboard](doc/img/host-stats.png)

# 2. Installation

Great!  You have decided to give lemmy-synapse a shot.  There are only a couple of
prerequisites and things you should figure out in advance.

## 2.1 Prerequisites

### 2.1.1 SSH Access

Needless to say, you should have SSH access to your server.


