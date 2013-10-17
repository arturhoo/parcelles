require 'facter'

Facter.add("lsblk") do
  setcode do
    lsblk = Facter::Util::Resolution.exec('lsblk --raw --noheadings --output=NAME')
    lsblk.split("\n").join(",")
  end
end
