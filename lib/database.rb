require 'yaml'
require 'singleton'
require 'securerandom'

class Database
  include Singleton

  STORAGE = 'database.yaml'

  NotFoundError = Class.new(StandardError)

  def initialize
    @state = YAML.load_file(STORAGE) rescue {}
    @state.default_proc = proc do |hash, key|
      hash[key] = {}
    end
  end

  def query(model, conditions = {}, &block)
    @state[model.name].values.select do |record|
      conditions.all? do |key, value|
        record.send(key) == value
      end
    end
  end

  def get(model, id)
    @state[model.name].fetch(id) do
      raise NotFoundError, "#{model.name} ##{id} does not exist"
    end
  end

  def save(record)
    @state[record.class.name][record.id] = record
    persist
    true
  end

  def destroy(record)
    @state[record.class.name].delete(record.id)
    persist
    true
  end

  def persist
    File.write(STORAGE, YAML.dump(@state))
  end

  class Model
    attr_accessor :id

    def self.all
      Database.instance.query(self)
    end

    def self.where(conditions = {}, &block)
      Database.instance.query(self, conditions, &block)
    end

    def self.find(id)
      Database.instance.get(self, id)
    end

    def self.create(attributes = {})
      new(attributes).tap(&:save)
    end

    def initialize(attributes = {})
      assign(attributes)
    end

    def assign(attributes)
      attributes.each do |key, value|
        send "#{key}=", value if respond_to? "#{key}="
      end
    end

    def update(attributes)
      assign(attributes)
      save
    end

    def save
      self.id ||= SecureRandom.uuid
      Database.instance.save(self)
    end

    def destroy
      Database.instance.destroy(self)
    end
  end
end
