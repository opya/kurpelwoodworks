DeepCover.configure do
  ignore_uncovered :raise, :default_argument
  detect_uncovered :trivial_if
  paths %w[lib]
  exclude_paths %w[config db]
end
