require 'open3'
require 'pronto'
require 'pronto/sorbet/version'

module Pronto
  module Sorbet
    class Runner < ::Pronto::Runner
      SEVERITY = :warning

      def sorbet_executable
        @sorbet_executable ||= begin
          path = `git config pronto.sorbet`.strip
          !path.empty? && File.executable?(path) ? path : 'srb'
        end
      end

      def sorbet_errors
        Dir.chdir(repo_path) do
          output, _ = Open3.capture2e(sorbet_executable, 'tc')

          output.split("\n")[0..-2].slice_before do |line|
            ![nil, ' '].include?(line[0])
          end.map do |lines|
            filename, line, message = lines.first&.split(':', 3)
            next if line.nil? || message.nil?
            { filename: filename, line: line.to_i, message: message.lstrip,
              details: lines[1..-1].join("\n").rstrip }
          end.compact
        end
      rescue SystemCallError
        []
      end

      def run
        return [] unless ruby_patches.any?

        sorbet_errors.map do |error|
          patch = ruby_patches.find do |patch|
            patch.new_file_full_path.relative_path_from(repo_path).to_s == error[:filename]
          end
          next if patch.nil?

          line = patch.added_lines.find { |l| l.new_lineno == error[:line] } || patch.added_lines.first
          next if line.nil?

          Message.new(line.patch.delta.new_file[:path], line, SEVERITY,
                      "#{error[:message]}\n#{error[:details]}", nil, self.class)
        end.compact
      end
    end
  end
end
