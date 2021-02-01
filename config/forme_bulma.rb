module Forme
  register_config(
    :bulma,
    labeler: :bulma,
    wrapper: :bulma,
    serializer: :bulma,
	error_handler: :bulma
  )
  class Labeler::Bulma
    Forme.register_transformer(:labeler, :bulma, new)

    # Return an array with a label tag as the first entry and +tag+ as
    # a second entry.  If the +input+ has a :label_for option, use that,
    # otherwise use the input's :id option.  If neither the :id or
    # :label_for option is used, the label created will not be
    # associated with an input.
    def call(tag, input)
      unless id = input.opts[:id]
        if key = input.opts[:key]
          namespaces = input.form_opts[:namespace]
          id = "#{namespaces.join('_')}#{'_' unless namespaces.empty?}#{key}"
          if key_id = input.opts[:key_id]
            id += "_#{key_id.to_s}"
          end
        end
      end

      label_attr = input.opts[:label_attr]
      label_attr = label_attr ? label_attr.dup : { class: 'label'}
      
      label_attr[:for] = label_attr[:for] === false ? nil : input.opts.fetch(:label_for, id)
      label = input.opts[:label]
      lpos = input.opts[:label_position] || ([:radio, :checkbox].include?(input.type) ? :after : :before)
      
      case input.type
      when :checkbox, :radio
        label = if lpos == :before
          [label, ' ', tag]
        else
          [tag, ' ', label]
        end
        input.tag(:label, label_attr, label)
      when :submit
        [tag]
      else
        label = input.tag(:label, label_attr, [input.opts[:label]])
        if lpos == :after
          [tag, ' ', label]
        else
          [label, ' ', tag]
        end
      end
    end
  end

  class Wrapper::Bulma < Wrapper
    # Wrap the input in the tag of the given type.

    def call(tag, input)
      attr = input.opts[:wrapper_attr] ? input.opts[:wrapper_attr].dup : { }
      klass = attr[:class] ? attr[:class].split(' ').unshift('control').uniq : ['control']

      attr[:class] = klass.sort.uniq.join(' ').strip
      [input.tag(:div, {class: 'field'}, [input.tag(:div, attr, [tag])])]
    end
    
    Forme.register_transformer(:wrapper, :bulma, new)
  end

  class Serializer::Bulma < Serializer
    Forme.register_transformer(:serializer, :bulma, new)

    def call(tag)
      # All textual <input>, <textarea>, and <select> elements with .input
      case tag
      when Tag
        case tag.type
        when :input
          # default to <input type="text"...> if not set
          tag.attr[:type] = :text if tag.attr[:type].nil?
          
          case tag.attr[:type].to_sym
          when :checkbox, :radio, :hidden
            # .input class causes rendering problems, so remove if found
            tag.attr[:class].gsub!(/\s*input\s*/,'') if tag.attr[:class]
            tag.attr[:class] = nil if tag.attr[:class] && tag.attr[:class].empty?
            
          when :file
            tag.attr[:class] = nil unless tag.attr[:class] && tag.attr[:class].strip != ''
          
          when :submit, :reset
            klass = ['button']
            if tag.attr[:class] && tag.attr[:class].strip != ''
              tag.attr[:class].split(' ').each { |c| klass.push c }
            end
            tag.attr[:class] = klass.uniq
            tag.attr[:class].join(' ')
          else
            klass = tag.attr[:class] ? "input #{tag.attr[:class].to_s}" : ''
            tag.attr[:class] = "input #{klass.gsub(/\s*input\s*/,'')}".strip
          end
          
          return "<#{tag.type}#{attr_html(tag.attr)}/>"
          
        when :textarea, :select
          klass = tag.attr[:class] ? "textarea #{tag.attr[:class].to_s}" : ''
          tag.attr[:class] = "textarea #{klass.gsub(/\s*input\s*/,'')}".strip
          return "#{serialize_open(tag)}#{call(tag.children)}#{serialize_close(tag)}"
        else
          super
        end
      else
        super
      end
    end
  end

  class ErrorHandler::Bulma < ErrorHandler
    Forme.register_transformer(:error_handler, :bulma, new)

    # Return tag with error message span tag after it.
    def call(tag, input)
      if tag.is_a?(Tag)
        binding.pry
        tag.attr[:class] = tag.attr[:class].to_s.gsub(/\s*error\s*/,'')
        tag.attr.delete(:class) if tag.attr[:class].to_s == ''
      end

      attr = input.opts[:error_attr]
      attr = attr ? attr.dup : {}
      Forme.attr_classes(attr, 'help is-danger')

      return [tag] if input.opts[:skip_error_message]

      if input.opts[:wrapper_attr]
        Forme.attr_classes(input.opts[:wrapper_attr], 'help is-danger')
      else
        input.opts[:wrapper_attr] = { :class => 'help is-danger' }
      end
      tag[2].attr[:class] = tag[2].attr[:class].gsub(/\s*error/, '').concat(" is-danger")
      [tag, input.tag(:p, attr, input.opts[:error])]
    end
  end
end
