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

module ::Calendar
  class CalendarsController < ApplicationController
    before_action :find_optional_project
    before_action :authorize, except: %i[index]
    before_action :authorize_global, only: %i[index]

    before_action :find_calendar, only: %i[destroy]
    menu_item :calendar_view

    include Layout
    include PaginationHelper
    include SortHelper

    def index
      @views = visible_views
      render 'index', locals: { menu_name: project_or_global_menu }
    end

    def show
      render layout: 'angular/angular'
    end

    def destroy
      if @view.destroy
        flash[:notice] = t(:notice_successful_delete)
      else
        flash[:error] = t(:error_can_not_delete_entry)
      end

      redirect_to action: :index
    end

    private

    def find_optional_project
      return unless params[:project_id]

      @project = Project.find(params[:project_id])
      authorize
    rescue ActiveRecord::RecordNotFound
      render_404
    end

    def visible_views
      base_query = Query
                     .visible(current_user)
                     .joins(:views)
                     .where('views.type' => 'work_packages_calendar')

      if @project
        base_query = base_query.where('queries.project_id' => @project.id)
      end

      base_query.order('queries.name ASC')
    end

    def find_calendar
      @view = Query
                .visible(current_user)
                .find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render_404
    end
  end
end
