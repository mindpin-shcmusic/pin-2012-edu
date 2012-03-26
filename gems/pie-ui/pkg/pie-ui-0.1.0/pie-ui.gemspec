# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "pie-ui"
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["ben7th"]
  s.date = "2012-03-22"
  s.description = "Pie user interface lib used for mindpin.com"
  s.email = "ben7th@sina.com"
  s.extra_rdoc_files = ["CHANGELOG", "README.rdoc", "lib/pie-ui.rb", "lib/pie-ui/action_view_ext/auto_link_helper.rb", "lib/pie-ui/action_view_ext/bundle_helper.rb", "lib/pie-ui/action_view_ext/dom_util_helper.rb", "lib/pie-ui/action_view_ext/git_commit_helper.rb", "lib/pie-ui/action_view_ext/mindpin_layout_helper.rb", "lib/pie-ui/action_view_ext/partial_helper.rb", "lib/pie-ui/action_view_ext/xml_format_helper.rb", "lib/pie-ui/mindpin_logic_rule.rb", "lib/pie-ui/string_util.rb", "lib/repo/grit_init.rb"]
  s.files = ["CHANGELOG", "Manifest", "README.rdoc", "Rakefile", "init.rb", "lib/pie-ui.rb", "lib/pie-ui/action_view_ext/auto_link_helper.rb", "lib/pie-ui/action_view_ext/bundle_helper.rb", "lib/pie-ui/action_view_ext/dom_util_helper.rb", "lib/pie-ui/action_view_ext/git_commit_helper.rb", "lib/pie-ui/action_view_ext/mindpin_layout_helper.rb", "lib/pie-ui/action_view_ext/partial_helper.rb", "lib/pie-ui/action_view_ext/xml_format_helper.rb", "lib/pie-ui/mindpin_logic_rule.rb", "lib/pie-ui/string_util.rb", "lib/repo/grit_init.rb", "pie-ui.gemspec"]
  s.homepage = "http://github.com/ben7th/pie-ui"
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Pie-ui", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = "pie-ui"
  s.rubygems_version = "1.8.11"
  s.summary = "Pie user interface lib used for mindpin.com"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
