# frozen_string_literal: true

# Class for Nvidia Infiniband fact functions
class Facter::Util::NvidiaInfiniband
  LSPCI_IB_PCI_REGEX = %r{\[15b3:}.freeze
  LSPCI_IB_REGEX = %r{(Network|Infiniband) controller: Mellanox Technologies}.freeze

  # lspci is a delegating helper method intended to make it easier to stub the
  # system call without affecting other calls to Facter::Core::Execution.execute
  def self.lspci(command = 'lspci 2>/dev/null')
    Facter::Core::Execution.execute(command)
  end

  # Returns the number of InfiniBand interfaces found
  # in lspci output
  #
  # @return [Integer]
  #
  # @api private
  def self.count_ib_devices
    count = 0
    if Facter::Core::Execution.which('lspci')
      output = lspci
      matches = output.scan(LSPCI_IB_PCI_REGEX)
      count = matches.flatten.reject { |s| s.nil? }.length
      return count if count.positive?

      matches = output.scan(LSPCI_IB_REGEX)
      count = matches.flatten.reject { |s| s.nil? }.length
    end
    count
  end
end
