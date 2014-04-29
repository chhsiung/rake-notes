require 'yaml'

module Rake
  module Notes
    class Configuration
      @annotations = ["OPTIMIZE", "FIXME", "TODO"]

      def self.read_annotations(file='.annotations')
        if File.exists?(file)
          additional_annotations = File.readlines(file)
          @annotations += additional_annotations.map{|s| s.strip}
          @annotations.uniq!
        end
      end

      def self.annotations
        @annotations
      end

      def self.add_annotation(annotation)
        @annotations << annotation
      end

      def self.annotations_string
        @annotations.join("|")
      end
    end
  end
end