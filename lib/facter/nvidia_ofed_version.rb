# frozen_string_literal: true

# Fact: nvidia_ofed_version
#
# Purpose: Determine version of Mellanox OFED installed
#
# Resolution:
#   Returns value based on output from ofed_info
#

Facter.add(:nvidia_ofed_version) do
  confine kernel: 'Linux'
  setcode do
    value = nil
    if Facter::Core::Execution.which('ofed_info')
      output = Facter::Core::Execution.execute('ofed_info -n 2>/dev/null')
      unless output.nil?
        value = output.strip
      end
    end
    value
  end
end
