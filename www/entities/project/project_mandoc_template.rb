require 'open3'

class ProjectMandocTemplate
  BASE_TEMPLATE = <<-BODY
.Dd $Mdocdate$
.Dt PROGNAME section
.Os
.Sh Продукт
.Nm %s
%s
  BODY

  class << self
    def for_project(project)
      mandoc_template = sprintf(
        BASE_TEMPLATE,
        project.name,
        project.description)
      sin, sout, serr = Open3.popen3("echo '#{mandoc_template}' | mandoc -T html -O style=/assets/mandoc.css")

      sout.read
    end
  end
end
