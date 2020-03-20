class ProjectImage < Sequel::Model
  many_to_one :projects
end
