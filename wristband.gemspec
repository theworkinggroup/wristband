# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{wristband}
  s.version = "1.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jack Neto"]
  s.date = %q{2009-03-26}
  s.description = %q{Simplifies the process of authenticating and authorizing users.}
  s.email = %q{jack@theworkinggroup.ca}
  s.extra_rdoc_files = ["lib/wristband/application_extensions.rb", "lib/wristband/authority_check.rb", "lib/wristband/support.rb", "lib/wristband/user_extensions.rb", "lib/wristband.rb", "README.rdoc"]
  s.files = ["generators/wristband/templates/app/controllers/sessions_controller.rb", "generators/wristband/templates/app/controllers/users_controller.rb", "generators/wristband/templates/app/models/user.rb", "generators/wristband/templates/app/models/user_notifier.rb", "generators/wristband/templates/app/views/sessions/new.html.haml", "generators/wristband/templates/app/views/user_notifier/email_verification.text.html.rhtml", "generators/wristband/templates/app/views/user_notifier/email_verification.text.plain.rhtml", "generators/wristband/templates/app/views/user_notifier/forgot_password.text.html.rhtml", "generators/wristband/templates/app/views/user_notifier/forgot_password.text.plain.rhtml", "generators/wristband/templates/app/views/users/forgot_password.html.haml", "generators/wristband/templates/app/views/users/index.html.haml", "generators/wristband/templates/db/migrate/create_wristband_tables.rb", "generators/wristband/wristband_generator.rb", "init.rb", "lib/wristband/application_extensions.rb", "lib/wristband/authority_check.rb", "lib/wristband/support.rb", "lib/wristband/user_extensions.rb", "lib/wristband.rb", "Manifest", "Rakefile", "README.rdoc", "test/database.yml", "test/fixtures/crypted_password_users.yml", "test/fixtures/plain_text_password_users.yml", "test/fixtures/users.yml", "test/schema.rb", "test/test_helper.rb", "test/unit/crypted_password_users_test.rb", "test/unit/has_authorities_test.rb", "test/unit/plain_text_password_user_test.rb", "wristband.gemspec"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/theworkinggroup/wristband}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Wristband", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{wristband}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Simplifies the process of authenticating and authorizing users.}
  s.test_files = ["test/test_helper.rb", "test/unit/crypted_password_users_test.rb", "test/unit/has_authorities_test.rb", "test/unit/plain_text_password_user_test.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
