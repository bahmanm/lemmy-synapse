####################################################################################################
# Copyright (c) 2023 Bahman Movaqar
#
# This file is part of lemmy-synapse.
# lemmy-synapse is free software: you can redistribute it and/or modify it under the terms of the GNU
# General Public License as published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# lemmy-synapse is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without
# even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License along with lemmy-synapse.
# If not, see <https://www.gnu.org/licenses/>.
####################################################################################################

SHELL := /usr/bin/env -S bash -o pipefail

.DEFAULT_GOAL := install

export NAME := lemmy-synapse
export ROOT := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
export src.dir := $(ROOT)
export build.dir := $(ROOT)_build/
lemmy-synapse.archive := $(build.dir)$(NAME).tar

####################################################################################################

.PHONY : bmakelib/bmakelib.mk
include bmakelib/bmakelib.mk

.PHONY : $(src.dir)cluster/Makefile
include $(src.dir)cluster/Makefile

.PHONY : $(src.dir)ansible/Makefile
include $(src.dir)ansible/Makefile

.PHONY : $(src.dir)bin/Makefile
include $(src.dir)bin/Makefile


####################################################################################################

$(build.dir) :
	mkdir -p $(@)

####################################################################################################

.PHONY : $(lemmy-synapse.archive)

$(lemmy-synapse.archive) : | $(build.dir)
	tar --create --file $(@) -T /dev/null

####################################################################################################

.PHONY : package

package : $(lemmy-synapse.archive) cluster.package bin.package

####################################################################################################

.PHONY : clean

clean :
	-rm -rf $(build.dir)

####################################################################################################

.PHONY : install

install : clean package
install : ansible.lemmy-synapse-archive := $(lemmy-synapse.archive)
install : ansible.lemmy-synapse-dashboards := $(cluster.srcdir)grafana/dashboards
install : $(ansible.playbook.install)
