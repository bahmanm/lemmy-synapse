####################################################################################################
# Copyright (c) 2023 Bahman Movaqar
#
# This file is part of lemmy-meter.
# lemmy-meter is free software: you can redistribute it and/or modify it under the terms of the GNU
# General Public License as published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# lemmy-meter is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without
# even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License along with lemmy-meter.
# If not, see <https://www.gnu.org/licenses/>.
####################################################################################################

SHELL := /usr/bin/env -S bash -o pipefail

.DEFAULT_GOAL := up

export NAME := lemmy-synapse
export ROOT := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

ifeq ($(POSTGRESQL_PASSWORD),)
$(error Provide a value for variable POSTGRESQL_PASSWORD)
endif

####################################################################################################

define docker-compose
export POSTGRESQL_PASSWORD \
&& docker compose \
	--file $(ROOT)docker-compose.yml \
	--project-name $(NAME)
endef

####################################################################################################

.PHONY : cluster.up

cluster.up :
	$(docker-compose) \
		up \
		--remove-orphans \
		--pull always \
		--detach

####################################################################################################

.PHONY : cluster.down

cluster.down :
	$(docker-compose) \
		down \
		--remove-orphans

