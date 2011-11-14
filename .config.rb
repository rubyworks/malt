qed do
  profile :cov do
    require 'simplecov'
    SimpleCov.start do
      coverage_dir 'log/coverage'
      add_group "Formats", "lib/malt/formats"
      add_group "Engines", "lib/malt/engines"
    end
  end
end


