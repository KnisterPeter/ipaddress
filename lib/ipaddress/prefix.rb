module IPAddress
  class Prefix

    include Comparable

    attr_reader :prefix

    def initialize(num)
      @prefix = num.to_i
    end

    def bits
      "1" * @prefix + "0" * (@size - @prefix)
      #sprintf "%0#@sizeb",(@mask & ~(@mask >> @prefix))
    end
  
    def to_s
      "#@prefix"
    end
    alias_method :inspect, :to_s

    def to_i
      @prefix
    end

    def <=>(oth)
      @prefix <=> oth.to_i
    end

   end # class Prefix

  class Prefix32 < Prefix

    def initialize(num)
      raise ArgumentError unless (1..32).include? num
      @mask = 0xffffffff
      @size = 32
      super(num)
    end

    def to_ip
      [bits].pack("B*").unpack("CCCC").join(".")
    end

    def octets
      to_ip.split(".").map{|i| i.to_i}
    end

    def to_u32
      [bits].pack("B*").unpack("N").first
    end
    
    def [](index)
      octets[index]
    end

    def hostmask
      [~to_u32].pack("N").unpack("CCCC").join(".")
    end
    
    def self.parse_netmask(netmask)
      octets = netmask.split(".").map{|i| i.to_i}
      num = octets.pack("C"*octets.size).unpack("B*").first.count "1"
      return IPAddress::Prefix.new(num)
    end
    
  end # class Prefix32 < Prefix

  class Prefix128 < Prefix

    def initialize(num)
      raise ArgumentError unless (1..128).include? num
      @mask = 0xffffffffffffffffffffffffffffffff
      @size = 128
      super(num)
    end

    def to_u128
      [bits].pack("B*").unpack("N4").first
    end
      

  end
  
  

end # module IPAddress