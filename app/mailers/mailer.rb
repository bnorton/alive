class Mailer < ActionMailer::Base
  def self.inherited(base)
    from = Rails.env.test? ? 'test@test.host' : ENV['SENDGRID_USERNAME']

    base.send(:default, :from => from)
    base.send(:default, :template_path => "emails/#{base.name.underscore.gsub(/_mailer/, '').pluralize}")
  end

  def self.deliver(name, *args)
    return unless ENV['SENDGRID_USERNAME'].present?

    self.send(name, *args).deliver_now
  end
end
