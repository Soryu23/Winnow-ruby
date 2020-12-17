require 'consistent_hash'
require_relative 'lib/winnow'

str_a = <<-EOF
  'Twas brillig, and the slithy toves
  Did gyre and gimble in the wabe;
  This is copied.
  All mimsy were the borogoves,
  And the mome raths outgrabe Code running man.
EOF

str_b = <<-EOF
  "Beware the Jabberwock, my son!
  The jaws that Code running man bite, the claws that catch!
  Beware the Jubjub bird, and shun
  The frumious -- This is copied. -- Bandersnatch!"
EOF

fprinter = Winnow::Fingerprinter.new(
  guarantee_threshold: 13, noise_threshold: 9
)

f1 = fprinter.fingerprints(str_a, source: 'Stanza 1')
f2 = fprinter.fingerprints(str_b, source: 'Stanza 2')

print Winnow::Fingerprinter.instance_methods(false)
puts '/s'

print f1.keys & f2.keys
puts f1[(f1.keys & f2.keys)[0]]

matches = Winnow::Matcher.find_matches(f1, f2)

# Because 'This is copied' is longer than the guarantee threshold, there might
# be a couple of matches found here. For the sake of brevity, let's only look at
# the first match found.

# match = matches.first

matches.each do |match|
  # It's possible for the same key to appear in a document multiple times (e.g. if
  # 'This is copied' appears more than once). Winnow::Matcher will return all
  # matches from the same key in array.
  #
  # In this case, we know there's only one match (because 'This is copied' appears
  # only once in each document), so let's only look at the first one.
  match_a = match.matches_from_a.first
  match_b = match.matches_from_b.first

  p match_a.index, match_b.index # 71, 125

  match_context_a = str_a[match_a.index - 10..match_a.index + 20]
  match_context_b = str_b[match_b.index - 10..match_b.index + 20]

  # Match from Stanza 1: "e wabe;\nThis is copied.\nAll mim"
  puts "Match from #{match_a.source}: #{match_context_a.inspect}"

  # Match from Stanza 2: "ious -- This is copied. -- Band"
  puts "Match from #{match_b.source}: #{match_context_b.inspect}"
end
