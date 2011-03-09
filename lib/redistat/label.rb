module Redistat
  class Label
    include Database
    
    attr_reader :raw
    attr_reader :connection_ref
    
    def self.create(name, options = {})
      self.new(name, options).save
    end
    
    def initialize(str, options = {})
      @options = options
      @raw = str.to_s
    end

    def db
      super(@options[:connection_ref])
    end
    
    def name
      @options[:hashed_label] ? hash : @raw
    end
    
    def hash
      @hash ||= Digest::SHA1.hexdigest(@raw)
    end
    
    def save
      @saved = (db.set("#{KEY_LEBELS}#{hash}", @raw) == "OK") if @options[:hashed_label]
      self
    end
    
    def saved?
      @saved ||= false
    end
    
    def groups
      return @groups if @groups
      @groups = []
      parent = ""
      @raw.split(GROUP_SEPARATOR).each do |part|
        if !part.blank?
          group = ((parent.blank?) ? "" : "#{parent}/") + part
          @groups << group
          parent = group
        end
      end
      @groups.reverse!
    end
    
    def parent
      @parent ||= self.class.new(parent_group)
    end
    
    def parent_group
      groups[1]
    end
    
    def sub_group
      @raw.split(GROUP_SEPARATOR).last
    end
    
    def update_index
      groups.each do |group|
        label = self.class.new(group)
        break if label.parent_group.nil?
        db.sadd("#{LABEL_INDEX}#{label.parent_group}", label.sub_group) == "OK" ? true : false
      end
    end
    
  end
end