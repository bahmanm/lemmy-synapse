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

ansible.srcdir := $(src.dir)ansible/
ansible.requirements := $(ansible.srcdir)requirements.txt
ansible.venv := $(build.dir)ansible-venv/
ansible.venv.activate := source $(ansible.venv)bin/activate

####################################################################################################

ansible.playbook.install := $(ansible.srcdir)playbooks/install-reconfigure/configure-lemmy-synapse.yml
ansible.playbook.install.requirements := $(ansible.srcdir)playbooks/install-reconfigure/requirements.yml

####################################################################################################

$(ansible.venv) : | $(build.dir)
	python3 -mvenv --prompt 'ansible' $(@) \
	&& source $(@)bin/activate \
	&& pip install --upgrade pip \
	&& pip install -r $(ansible.requirements)

####################################################################################################

.PHONY : $(ansible.playbook.install.requirements)

$(ansible.playbook.install.requirements) : | $(ansible.venv)
	$(ansible.venv.activate) \
	&& ansible-galaxy install -r $(@)

####################################################################################################

$(ansible.playbook.install) : bmakelib.error-if-blank( ansible.lemmy-synapse-archive )
$(ansible.playbook.install) : bmakelib.error-if-blank( ansible.lemmy-synapse-server )
$(ansible.playbook.install) : bmakelib.default-if-blank( ansible.verbosity, )
$(ansible.playbook.install) : bmakelib.error-if-blank( ansible.lemmy-synapse-dashboards )
$(ansible.playbook.install) : $(ansible.playbook.install.requirements)
$(ansible.playbook.install) : | $(ansible.venv)
	$(ansible.venv.activate) \
	&& ansible-playbook \
		$(ansible.verbosity) \
		-i '$(ansible.lemmy-synapse-server),' \
		-e 'lemmy_synapse_archive_path=$(ansible.lemmy-synapse-archive)' \
		-e 'lemmy_synapse_installation_config_path=$(src.dir)installation-config.yml' \
		-e 'lemmy_synapse_dashboards_path=$(ansible.lemmy-synapse-dashboards)' \
		--become \
		--ask-become-pass \
		$(@)
