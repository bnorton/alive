module ApplicationHelper
  def csrf_form_tags
    tag('input', :type => 'hidden', :name => request_forgery_protection_token, :value => form_authenticity_token).html_safe
  end
end
