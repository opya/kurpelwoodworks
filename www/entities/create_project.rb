class CreateProject
  PROJECT_PARAMS = [:work_name, :name, :description, :started, :completed]
  ASK_FOR_INPUT = "%s: %s "

  attr_accessor :project

  def initialize(project)
    @project = project
    @project_params = PROJECT_PARAMS.to_enum
    @pp_cursor = @project_params.next
  end

  def run
    while true do
      print ask_for_input

      begin
        case @pp_cursor
        when :work_name, :name, :started, :completed
          standard_requirements
        when :description
          description_requirements
        end
      rescue StopIteration
        break
      end
    end

    save_project
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

  def standard_requirements
    arg = read_line
    @project.send("#{@pp_cursor}=", arg) if (arg && arg.length != 0)
    project_params_next
  end

  def description_requirements
    description_tmp_file = Tempfile.new

    _description = @project.new? ? ask_for_input : @project.send("#{@pp_cursor}")

    File.open(description_tmp_file.path, "w") do |f|
      f.write(_description)
    end

    system("vim #{description_tmp_file.path}")

    project.description = File.read(description_tmp_file.path).strip

    project_params_next

    puts ""
  end

  def project_params_next
    @pp_cursor = @project_params.next
  end

  def save_project
    if @project.valid?
      @project.save

      action = @project.new? ? 'created' : 'updated'
      puts "Successfully #{action} project with work name '#{@project.work_name}'"
    else
      @project.errors.each do |key, error|
        puts "#{key.to_s} #{error.first}"
      end
    end
  end

  def ask_for_input
    sprintf(ASK_FOR_INPUT, @pp_cursor, @project.send("#{@pp_cursor}").to_s)
  end
end

