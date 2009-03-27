module Wristband
  module Support
    CONSONANTS = %w( b c d f g h j k l m n p qu r s t v w x z ch cr fr nd ng nk nt ph pr rd sh sl sp st th tr )
    VOWELS = %w( a e i o u y )
  
    def random_string(length = 8)
      (1 .. length).collect { |n|
        (n % 2 != 0) ? CONSONANTS[rand(CONSONANTS.size)] : VOWELS[rand(VOWELS.size)]
      }.to_s[0, length]
    end
    module_function :random_string
  
    def encrypt_with_salt(password, salt)
      return password unless (salt and !salt.empty?)
    
      Digest::SHA1.hexdigest([ password, salt ].to_s)
    end
    module_function :encrypt_with_salt
  
    def random_salt(length = nil)
      salt = Digest::SHA1.hexdigest([ rand, rand, random_string(64), rand, rand ].to_s)
    
      length ? salt[0, length] : salt
    end
    module_function :random_salt
  
  end
end