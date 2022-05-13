# A solution for the min distance to apartment problem.
# The problem is to choose the ideal block in which to rent an apartment to minimize the distance to the services that you find essential
# The blocks will be represented as an array of hashes with true or false values for each essential service.
# I chose to write this code so the services can be added or changed depending without breaking the code
#
# To be quite honest this took me longer than I'd like to admit
# to work the bugs out of this solution. The first solution of full forward and backward passage is not necessary since
# once a value is reached in backward passage equal to the current value we will be entering wrong values on backward passage.
# Taking the minimum of the two values seems wrong as well since when the later value is minimum is predetermined.
#
# Sample input
# @blocks = [
#   {
#     gym: false,
#     school: true,
#     store: false
#   },
#   {
#     gym: true,
#     school: false,
#     store: false
#   },
#   {
#     gym: true,
#     school: true,
#     store: false
#   },
#   {
#     gym: false,
#     school: true,
#     store: false
#   },
#   {
#     gym: false,
#     school: true,
#     store: true
#   }
# ]
#
# Sample output
#
# [{:gym=>false, :school=>false, :store=>true},
#  {:gym=>false, :school=>false, :store=>true},
#  {:gym=>false, :school=>false, :store=>false},
#  {:gym=>false, :school=>false, :store=>true},
#  {:gym=>false, :school=>true, :store=>true},
#  {:gym=>false, :school=>false, :store=>false},
#  {:gym=>false, :school=>false, :store=>true},
#  {:gym=>false, :school=>false, :store=>false},
#  {:gym=>false, :school=>true, :store=>true},
#  {:gym=>false, :school=>false, :store=>false},
#  {:gym=>true, :school=>false, :store=>true}]
# [10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 2]
#

reqs = [:gym, :school, :store, :dojo]
@blocks = rand(5..20).times.map {reqs.map {|req| [req, [true, false, false].sample] }.to_h }
pp @blocks

distance_since = reqs.reduce(Hash.new) { |r, i| r[i] = @blocks.size; r  }


i = 0
def backupdate(index)
  block = @blocks[index].select { |k, v| v }.map { |k, v| v = 0; [k, v] }.to_h
  index -= 1
  return 0 unless index >= 0
  while index >=0 && @blocks[index].merge(block) { |_k, v1, v2| v1 > v2 }.any? { |_k, v| v }
    block = block.map { |e| e[1] += 1; e }.to_h
    @blocks[index].merge!(block) { |_k, v1, v2| [v1, v2].min }
    index -= 1
  end
  0
end

while i < @blocks.size
  block = @blocks[i]
  distance_since = block.merge(distance_since) { |_k, v1, v2| v1 ? backupdate(i) : v2 + 1 }
  @blocks[i] = distance_since
  i += 1
end

pp @blocks.map { |b| b.map { |_k, v| v }.max }
