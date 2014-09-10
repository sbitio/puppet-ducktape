class Hiera
  module Backend
    class Yaml_hierarchy_expander_backend
      def initialize(cache=nil)
        require 'yaml'
        Hiera.debug("Hiera YAML_hierarchy_expander backend starting")

        @cache = cache || Filecache.new
      end

      def lookup(key, scope, order_override, resolution_type)
        answer = nil

        Hiera.debug("Looking up #{key} in YAML_hierarchy_expander backend")

        # Prepare expanders.
        expanders = {}
        if Config[:yaml_hierarchy_expander] && Config[:yaml_hierarchy_expander][:expanders]
          Config[:yaml_hierarchy_expander][:expanders].each do |expander|
            if scope.include? expander
              var = "%{#{expander}}"
              expanders[var] = scope[expander]
            else
              Hiera.warn "'#{expander}' expander not in scope. Ignoring."
            end
          end
        end

        # Get the raw hierarchy.
        # # This extracted from Backend.datasources().
        hierarchy = [Config[:hierarchy]].flatten
        hierarchy.insert(0, order_override) if order_override

        # Unroll hierarchy lines containing expanders.
        expanders.each do |expander_var, items|
          Hiera.debug("Expanding #{expander_var}")
          hierarchy.map! do |source|
            if source.include? expander_var
              Hiera.debug("  Match in #{source}")
              lines = []
              items.each do |item|
                lines << source.gsub(expander_var, item)
              end
              lines
            else
              source
            end
          end
          hierarchy.flatten!
        end

        # Interpolate and expand wildcards.
        h2 = []
        datadir = Backend.datadir(:yaml_hierarchy_expander, scope)
        Backend.datasources(scope, order_override, hierarchy) do |source|
          if source.end_with? '*'
            Hiera.debug("Expanding wildcard #{source}")
            h2 << Dir["#{datadir}/#{source}.yaml"].map {|path| path.gsub(datadir + "/", "").chomp(".yaml") }
          else
            h2 << source
          end
        end
        hierarchy = h2.flatten

        Backend.datasourcefiles(:yaml_hierarchy_expander, scope, "yaml", order_override, hierarchy) do |source, yamlfile|
          data = @cache.read_file(yamlfile, Hash) do |data|
            YAML.load(data) || {}
          end

          next if data.empty?
          next unless data.include?(key)

          # Extra logging that we found the key. This can be outputted
          # multiple times if the resolution type is array or hash but that
          # should be expected as the logging will then tell the user ALL the
          # places where the key is found.
          Hiera.debug("Found #{key} in #{source}")

          # for array resolution we just append to the array whatever
          # we find, we then goes onto the next file and keep adding to
          # the array
          #
          # for priority searches we break after the first found data item
          new_answer = Backend.parse_answer(data[key], scope)
          case resolution_type
          when :array
            raise Exception, "Hiera type mismatch: expected Array and got #{new_answer.class}" unless new_answer.kind_of? Array or new_answer.kind_of? String
            answer ||= []
            answer << new_answer
          when :hash
            raise Exception, "Hiera type mismatch: expected Hash and got #{new_answer.class}" unless new_answer.kind_of? Hash
            answer ||= {}
            answer = Backend.merge_answer(new_answer,answer)
          else
            answer = new_answer
            break
          end
        end

        return answer
      end

      private

      def file_exists?(path)
        File.exist? path
      end
    end
  end
end
