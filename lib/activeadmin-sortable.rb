require 'activeadmin-sortable/version'
require 'activeadmin'
require 'rails/engine'

module ActiveAdmin
  module Sortable
    module ControllerActions
      def sortable
        member_action :sort, :method => :post do
          resource.insert_at params[:position].to_i
          head 200
        end
      end
    end

    module TableMethods
      HANDLE = '&#x2195;'.html_safe

      def sortable_handle_column
        column '', :class => "activeadmin-sortable" do |resource|

          chained_resource_route = [resource]

          resource_config = active_admin_config
          if(resource_config.belongs_to?)
            resource_config = resource_config.belongs_to_config.target
            resource = resource.send(resource_config.resource_class_name.gsub(/^::/,"").downcase)
            chained_resource_route << resource
          end

          sort_url = url_for([:sort, :admin, *(chained_resource_route.reverse)])
          content_tag :span, HANDLE, :class => 'handle', 'data-sort-url' => sort_url
        end
      end
    end

    ::ActiveAdmin::ResourceDSL.send(:include, ControllerActions)
    ::ActiveAdmin::Views::TableFor.send(:include, TableMethods)

    class Engine < ::Rails::Engine
      # Including an Engine tells Rails that this gem contains assets
    end
  end
end


