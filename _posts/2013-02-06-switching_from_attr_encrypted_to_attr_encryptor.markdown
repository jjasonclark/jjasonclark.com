---
layout: post
date: 2013-02-06
comments: true
categories: ruby, programming
keywords: ruby, programming, gem, security, encryption
description: How to switch from attr_encrypted to attr_encryptor gem for better security
summary: At work we are using the attr_encrypted gem to encrypt some PII on our data before it hits the database. The gem supports using a strong key but this turns out to not be enough. A Github issue was created to address leaking of data caused by using the same initialization vector (IV) and salt for every value. The method used by the attr_encrypted gem to create the IV and salt values is vulnerable. Additionally the IV should also be processed with the CBC-MAC method. The attr_encryptor was created to fix these issues.
title: Switching from attr_encrypted gem to attr_encryptor for better security
permalink: /switching_from_attr_encrypted_to_attr_encryptor
---

# Switching from attr_encrypted gem to attr_encryptor for better security

At work we are using the [attr\_encrypted gem][4] to encrypt some [PII][6] on our data before it hits the database. The gem supports using a strong key but this turns out to not be enough. A [Github issue][1] was created to address leaking of data caused by using the same [initialization vector (IV)][7] and [salt][8] for every value. The method used by the attr\_encrypted gem to create the IV and salt values is vulnerable. Additionally the IV should also be processed with the [CBC-MAC][13] method. The [attr\_encryptor][5] was created to fix these issues.

Besides changing gem names, to switch gems you will need to add the new `_iv` and `_salt` database columns for each of the encrypted values. And then re-encrypt all old values into the new system. Adding the new columns is trivial enough, but the re-encryption can be very tricky.

## Re-encrypting old values

At first I was hoping the attr\_encryptor gem could be used to decrypt the old values. I tried several things but nothing worked. Next best thing is a copy and paste of the original gem's decryption code. From the [Github source][9]

{% highlight ruby %}
# Decrypts a value for the attribute specified
#
# Example
#
#   class User
#     attr_encrypted :email
#   end
#
#   email = User.decrypt(:email, 'SOME_ENCRYPTED_EMAIL_STRING')
def decrypt(attribute, encrypted_value, options = {})
  options = encrypted_attributes[attribute.to_sym].merge(options)
  if options[:if] && !options[:unless] && !encrypted_value.nil? && !(encrypted_value.is_a?(String) && encrypted_value.empty?)
    encrypted_value = encrypted_value.unpack(options[:encode]).first if options[:encode]
    value = options[:encryptor].send(options[:decrypt_method], options.merge!(:value => encrypted_value))
    if options[:marshal]
      value = options[:marshaler].send(options[:load_method], value)
    elsif defined?(Encoding)
      encoding = Encoding.default_internal || Encoding.default_external
      value = value.force_encoding(encoding.name)
    end
    value
  else
    encrypted_value
  end
end
{% endhighlight %}

Which calls to the [encryptor gem][12] to do the actually decryption. The [decryption code][11]

{% highlight ruby %}
def crypt(cipher_method, *args) #:nodoc:
  options = default_options.merge(:value => args.first).merge(args.last.is_a?(Hash) ? args.last : {})
  raise ArgumentError.new('must specify a :key') if options[:key].to_s.empty?
  cipher = OpenSSL::Cipher::Cipher.new(options[:algorithm])
  cipher.send(cipher_method)
  if options[:iv]
    cipher.key = options[:key]
    cipher.iv = options[:iv]
  else
    cipher.pkcs5_keyivgen(options[:key])
  end
  yield cipher, options if block_given?
  result = cipher.update(options[:value])
  result << cipher.final
end
{% endhighlight %}

Basically this boils down to the following.

{% highlight ruby %}
def decrypt(value, key)
  cipher = OpenSSL::Cipher::Cipher.new('aes-256-cbc')
  cipher.decrypt
  cipher.pkcs5_keyivgen(key)
  result = cipher.update(value)
  result << cipher.final
end
{% endhighlight %}

## Finial migration
Putting this all together and you get the following migration. Easy enough task even with half a day wasted trying to get the gem to decrypt for me.

{% highlight ruby %}
class ReencryptAllValues < ActiveRecord::Migration
    class IterationCount
        def initialize(display_every=100)
            @iteration_count = 0
            @display_every = display_every
        end

        def inc_and_display(extra_text='')
            @iteration_count += 1
            puts("#{@iteration_count} rows processed. #{extra_text}") if 0 == @iteration_count % @display_every
        end
    end

    class FieldAccessor
        def initialize(value, target)
            @value_sym = value
            @target = target
        end

        def value
            @target.send(@value_sym)
        end

        def value=(value)
            @target.send("#{@value_sym}=", value)
        end

        def encrypted_value
            @target.send("encrypted_#{@value_sym}")
        end

        def encrypted_value=(value)
            @target.send("encrypted_#{@value_sym}=", value)
        end

        def clear_iv_and_salt
            @target.send("encrypted_#{@value_sym}_iv=", nil)
            @target.send("encrypted_#{@value_sym}_salt=", nil)
        end
    end

    class OldEncryptor
        def self.decrypt_value(value)
            crypt(:decrypt, value.unpack('m').first)
        end

        def self.encrypt_value(value)
            encrypted_value = crypt(:encrypt, value)
            [encrypted_value].pack('m')
        end

        private

        def self.crypt(method, value)
            cipher = OpenSSL::Cipher::Cipher.new('aes-256-cbc')
            cipher.send(method)
            cipher.pkcs5_keyivgen(AppConfig.attr_encrypted_secret)
            result = cipher.update(value)
            result << cipher.final
        end
    end

    class Reencrypter
        def self.convert_to_new_method(target, *value_syms)
            value_syms.each do |value_sym|
                fields = FieldAccessor.new(value_sym, target)
                if fields.encrypted_value.present?
                    fields.clear_iv_and_salt
                    fields.value = OldEncryptor.decrypt_value(fields.encrypted_value)
                end
            end
        end

        def self.convert_to_old_method(target, *value_syms)
            value_syms.each do |value_sym|
                fields = FieldAccessor.new(value_sym, target)
                if fields.encrypted_value.present?
                    fields.encrypted_value = OldEncryptor.encrypt_value(fields.value)
                    fields.clear_iv_and_salt
                end
            end
        end
    end

    def self.have_encrypted_values(advertiser)
        EncryptedFields.any? { |i| advertiser.send("encrypted_#{i}").present? }
    end

    def self.already_encrypted_values(advertiser)
        EncryptedFields.any? { |i| advertiser.send("encrypted_#{i}_iv").present? }
    end

    EncryptedFields = [:bank_account_number, :bank_routing_number, :federal_tax_id]

    def self.up
        return unless Rails.env.production?
        counter = IterationCount.new 1000
        converted = 0
        Advertiser.find_each do |advertiser|
            counter.inc_and_display "#{converted} converted"
            next unless have_encrypted_values(advertiser)
            next if already_encrypted_values(advertiser)

            Reencrypter.convert_to_new_method(advertiser, *EncryptedFields)
            advertiser.save(false)
            converted += 1
        end
    end

    def self.down
        return unless Rails.env.production?
        counter = IterationCount.new 1000
        converted = 0
        Advertiser.find_each do |advertiser|
            counter.inc_and_display "#{converted} converted"
            next unless have_encrypted_values(advertiser)
            next unless already_encrypted_values(advertiser)

            Reencrypter.convert_to_old_method(advertiser, *EncryptedFields)
            advertiser.save(false)
            converted += 1
        end
    end
end
{% endhighlight %}


[1]: https://github.com/shuber/attr_encrypted/issues/32 "Security issue with attr_encrypted"
[2]: https://github.com/shuber/attr_encrypted "attr_encrypted gem source"
[3]: https://github.com/danpal/attr_encryptor "attr_encryptor gem source"
[4]: http://rubygems.org/gems/attr_encrypted "attr_encyrpted on rubygems"
[5]: http://rubygems.org/gems/attr_encryptor "attr_encryptor on rubygems"
[6]: http://en.wikipedia.org/wiki/Personally_identifiable_information "Wikipedia on PII"
[7]: http://en.wikipedia.org/wiki/Initialization_vector "Wikipedia on IV"
[8]: http://en.wikipedia.org/wiki/Salt_(cryptography) "Wikipedia on salt"
[9]: https://github.com/shuber/attr_encrypted/blob/master/lib/attr_encrypted.rb#L166-190 "decryption function in attr_encrypted"
[10]: https://github.com/shuber/encryptor "encrytor gem source"
[11]: https://github.com/shuber/encryptor/blob/master/lib/encryptor.rb#L49-63 "encryptor decrypt method"
[12]: http://rubygems.org/gems/encryptor "encryptor gem on rubygems"
[13]: http://en.wikipedia.org/wiki/CBC-MAC "Wikipedia on CBC-MAC"
