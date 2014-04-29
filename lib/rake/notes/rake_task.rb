require 'rake'
require 'rake/tasklib'

require 'rake/notes/source_annotation_extractor'
require 'rake/notes/configuration'

module Rake
  module Notes
    class RakeTask < ::Rake::TaskLib
      include ::Rake::DSL if defined?(::Rake::DSL)

      def initialize(*args)
        Configuration.read_annotations
        yield self if block_given?

        desc "Enumerate all annotations (use notes:optimize, :fixme, :todo for focus)"
        task :notes do
          File.open('annotations.yml', 'w') do |f|
            SourceAnnotationExtractor.enumerate Configuration.annotations_string, :tag => true, :format => :yml, :out => f #$stdout
          end
        end

        namespace :notes do
          Configuration.annotations.each do |annotation|
            desc "Enumerate all #{annotation} annotations"
            task annotation.downcase.intern do
              SourceAnnotationExtractor.enumerate annotation
            end
          end

          desc "Enumerate a custom annotation, specify with ANNOTATION=CUSTOM"
          task :custom do
            SourceAnnotationExtractor.enumerate ENV['ANNOTATION']
          end
        end
      end
    end
  end
end

Rake::Notes::RakeTask.new
