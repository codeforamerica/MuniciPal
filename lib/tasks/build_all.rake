task :build_all do
  [ :debug, :release ].each do |t|
    $build_type = t
    Rake::Task["build"].execute
  end
end