# require 'active_record' unless defined? ActiveRecord

module HasUid
  extend ActiveSupport::Concern

  def self.included(base)
    base.send :include, InstanceMethods
    base.extend ClassMethods
  end

  module ClassMethods
    def has_uid(prefix = '', length = 16, attribute = :id, suffix = '', upcase = false)
      require 'securerandom'

      before_create {
        self.send("#{attribute}=", upcase ? (prefix + SecureRandom.base58(length) + suffix).upcase : prefix + SecureRandom.base58(length) + suffix)
      }

    end
  end

  module InstanceMethods

    def generate_uid(prefix = '', length = 16, attribute = :id, suffix = '', upcase = false)
      self.send("#{attribute}=", upcase ? (prefix + SecureRandom.base58(length) + suffix).upcase : prefix + SecureRandom.base58(length) + suffix)
    end

    def save_with_uid(*args)
      begin
        self.save!(*args)
      rescue ActiveRecord::RecordNotUnique => e
        uid_attempts = uid_attempts.to_i + 1
        retry if uid_attempts < 5
        raise e, 'UID creation retries exhausted'
      rescue ActiveRecord::RecordInvalid => e
        false
      end
    end

    def update_uid(prefix = '', length = 16, attribute = :id)
      require 'base58'

      begin
        self.update_attributes!(:"#{attribute}" => prefix + SecureRandom.base58(length))
      rescue ActiveRecord::RecordNotUnique => e
        uid_attempts = uid_attempts.to_i + 1
        retry if uid_attempts < 5
        raise e, 'UID creation retries exhausted'
      rescue ActiveRecord::RecordInvalid => e
        false
      end
    end
  end

end

ActiveRecord::Base.send(:include, HasUid)
