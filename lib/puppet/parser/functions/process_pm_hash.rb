module Puppet::Parser::Functions
  newfunction(:process_pm_hash, :type => :rvalue) do |args|
    units = {
      :store    => [],
      :net      => [],
      :protocol => [],
      :dcache   => [],
    }
    ugroups = Hash.new({})
    pools = Array.new()
    pgroups = Hash.new({})
    links = Hash.new({})
    lgroups = Hash.new({})
    lgroups_allowances = {
      :online    => false,
      :nearline  => false,
      :replica   => false,
      :custodial => false,
      :output    => false,
    }
    
    # Override the assignment method for the individual hashes so we can
    # implement "recursive" parsing.
    
    # For each new unit group add all units to the respective list of its
    # kind. Keep a map of ugroup name to all its units in the ugroups hash.
    def ugroups.[]= (key, val)
      super(key, val.values.flatten)
      val.each do |uclass, ulist|
        units[uclass] += ulist
      end
    end
    
    # For each new pool group, add all pools to the list of all pools.
    def pgroups.[]= (key, val)
      super(key, val)
      val.each do |pgroup, my_pools|
        pools += my_pools
      end
    end
    
    # links are broken down into three subparts:
    #   - ugroups
    #     Add every ugroup from this link to the hash of all ugroups. Keep
    #     a mapping of ugroup to all units in tmp.
    #   - pgroups
    #     Update the hash of all pgroups and the list of pools. Keep a
    #     mapping of pgroup to pools in tmp.
    #   - prefs
    #     Only the link itself needs to now whether preferences were set.
    def links.[]= (key, val)
      tmp = Hash.new
      
      if val.key?(:ugroups)
        val[:ugroups].each do |ugroup, uhash|
          tmp[:ugroups][ugroup] = uhash.values.flatten
          ugroups[ugroup] = uhash
        end
      else
        tmp[:ugroups] = {}
      end
      
      if val.key?(:pgroups)
        val[:pgroups].each do |pgroup, my_pools|
          tmp[:pgroups][pgroup] = my_pools
          pgroups[pgroup] = my_pools
        end
      else
        tmp[:groups] = {}
      end
      
      tmp[:prefs] = val.key?(:prefs) ? val[:prefs] : {}
      
      super(key, tmp)
      
    end
    
    # lgroups
    def lgroups.[]= (key, val)
      if val.key?(:allowances)
        lgroups[key][:allowance] = lgroups_allowances.merge(val[:allowances])
      else
        lgroups[key][:allowance] = lgroups_allowances
      end
      
      lgroups[key][:links] = Array.new()
      if val.key?(:links)
        val[:links].each do |link, link_details|
          lgroups[key][:links] += link
          links[link] = link_details
        end
      end
    end
    
    args[0].each do |pm_class, members|
      case pm_class
      when :units
        units.merge!(members)
      when :ugroups
        ugroups.merge!(members)
      when :pools
        pools += members
      when :pgroups
        pgroups.merge!(members)
      when :links
        links.merge!(members)
      when :lgroups
        lgroups.merge!(members)
      end
    end
    
    # Purge dublicates.
    units.each do |uclass, ulist| ulist.uniq! end
    ugroups.each do |ugroup, my_units| my_units.uniq! end
    pools.uniq!
    pgroups.each do |pgroup, my_pools| my_pools.uniq! end
    links.each do |link| link[:pgroups].uniq! end
    lgroups.each do |lgroup| lgroup[:links].uniq! end
    
    return {
      :units   => units,
      :ugroups => ugroups,
      :pools   => pools,
      :pgroups => pgroups,
      :links   => links,
      :lgroups => lgroups, 
    }
  end
end