module Breeze
	MAJOR = 1		# increment for new backwards incompatible changes
  MINOR = 0		# increment for new backward-compatible functionality
  PATCH = 0		# increment for backwards-compaitble bug fixes
  STATE = :pre # (nil|:pre|:alpha|:a) or every alphanumeric tag you'd like to append to your version.

  VERSION = "#{MAJOR}.#{MINOR}.#{PATCH}"
  VERSION = [VERSION, STATE.to_s].join(".") unless STATE.nil?
end

