#-- copyright
# OpenProject is an open source project management software.
# Copyright (C) 2012-2023 the OpenProject GmbH
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License version 3.
#
# OpenProject is a fork of ChiliProject, which is a fork of Redmine. The copyright follows:
# Copyright (C) 2006-2013 Jean-Philippe Lang
# Copyright (C) 2010-2013 the ChiliProject Team
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#
# See COPYRIGHT and LICENSE files for more details.
#++

class AddTlsModeToAuthSources < ActiveRecord::Migration[5.2]
  def change
    add_column :auth_sources, :tls_mode, :integer, default: 0, null: false
    LdapAuthSource.reset_column_information

    reversible do |dir|
      dir.up do
        LdapAuthSource.where(tls: true).update_all(tls_mode: 1)
      end

      dir.down do
        LdapAuthSource.where(tls_mode: 0).update_all(tls: false)
        LdapAuthSource.where(tls_mode: 1).update_all(tls: true)
      end
    end

    remove_column :auth_sources, :tls, :boolean, default: false, null: false
  end
end
