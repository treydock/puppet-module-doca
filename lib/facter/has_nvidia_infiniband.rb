# frozen_string_literal: true

# Fact: has_nvidia_infiniband
#
# Purpose: Determine if the system's hardware supports Mellanox InfiniBand.
#
# Resolution:
#   Returns true or false based on output from `lspci`.
#

require 'facter/util/nvidia_infiniband'

Facter.add(:has_nvidia_infiniband) do
  confine kernel: 'Linux'
  setcode do
    ib_device_count = Facter::Util::NvidiaInfiniband.count_ib_devices
    ib_device_count.positive?
  end
end
