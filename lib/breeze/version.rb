module Breeze
	MAJOR = 1		# increment for new backwards incompatible changes
  MINOR = 1		# increment for new backward-compatible functionality
  PATCH = 1		# increment for backwards-compaitble bug fixes
  PRE = nil # (nil|pre|alpha|a|beta) or every alphanumeric tag you'd like to append to your version.

  VERSION = [MAJOR, MINOR, PATCH, PRE].compact.join(".") 
end

