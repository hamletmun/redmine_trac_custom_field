require 'redmine'

Redmine::Plugin.register :redmine_trac_custom_field do
  name 'Trac num to ticket'
  author 'Seung Soo Mun'
  url 'https://github.com/hamletmun/redmine_trac_custom_field/' if respond_to?(:url)
  description 'A custom field that links your Redmine issue to Trac ticket number'
  version '0.1.1'

  requires_redmine :version_or_higher => '0.9.0'

  settings :partial => 'settings/redmine_trac_custom_field_settings',
    :default => {
      'trac_url' => 'http://path.to.trac.com/',
      'trac_project' => 'project_name',
      'new_window' => 'true', 
    }
end

class TracCustomFieldFormat < Redmine::CustomFieldFormat
  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::TagHelper

  def format_as_trac(value)
    if Setting.plugin_redmine_trac_custom_field['new_window'] == "true"
      target = 'blank'
    else
      target = ''
    end
    
    ActionController::Base.helpers.link_to(value, Setting.plugin_redmine_trac_custom_field['trac_url'] + "projects/" + Setting.plugin_redmine_trac_custom_field['trac_project'] + "/ticket/" + value, :target => target)
  end

  def escape_html?
    false
  end

  def edit_as
   "string"
  end
end

Redmine::CustomFieldFormat.map do |fields|
  fields.register TracCustomFieldFormat.new('trac', :label => :label_trac, :order => 8)
end
