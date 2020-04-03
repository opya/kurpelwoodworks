class CreateProject
  PROJECT_PARAMS = [:work_name, :name, :description, :started, :completed]
  ASK_FOR_INPUT = "Enter value for %s"

  attr_accessor :project

  def initialize(project)
    @project = project
  end

  def run
    while true do
      PROJECT_PARAMS.each do |key|
        puts sprintf(ASK_FOR_INPUT, key)
        if !project.new? and key != :description
          puts "Current #{key}: " + project.send("#{key}").to_s
        end

        if key == :description
          description_tmp_file = Tempfile.new

          File.open(description_tmp_file.path, "w") do |f|
            f.write(sprintf(ASK_FOR_INPUT, key))
          end

          system("vim #{description_tmp_file.path}")

          project.description = File.read(description_tmp_file.path).strip

          PROJECT_PARAMS.delete(key)
        else
          arg = read_line

          if project.new?
            unless arg.length == 0
              project.send("#{key}=", arg)
              PROJECT_PARAMS.delete(key)
            end
          else
            project.send("#{key}=", arg) unless arg.length == 0
            PROJECT_PARAMS.delete(key)
          end
        end

        break
      end

      break if PROJECT_PARAMS.length == 0
    end
    
    if project.valid?
      if project.new?
        puts "Successfully created project with name '#{project.work_name}'"
      else
        puts "Successfully updated project with name '#{project.work_name}'"
      end

      project.save
    else
      project.errors.each do |key, error|
        puts "#{key.to_s} #{error.first}"
      end
    end
  end

  private

  def read_line
    arg = nil

    $stdin.each do |line|
      arg = line.strip
      break
    end

    arg
  end
end

