module ::Boards
  class BoardsController < BaseController
    before_action :find_optional_project

    with_options only: [:index] do
      # The boards permission alone does not suffice
      # to view work packages
      before_action :authorize
      before_action :authorize_work_package_permission
    end

    before_action :authorize_global, only: :overview

    menu_item :board_view

    def index
      render layout: 'angular/angular'
    end

    def overview
      projects = Project.allowed_to(User.current, :show_board_views)
      @board_grids = Boards::Grid.includes(:project).where(project: projects)
      render layout: 'global'
    end

    current_menu_item :index do
      :board_view
    end

    current_menu_item :overview do
      :boards
    end

    private

    def authorize_work_package_permission
      unless current_user.allowed_to?(:view_work_packages, @project, global: @project.nil?)
        deny_access
      end
    end
  end
end
