# MontyHallProblem

Simulate the [Monty Hall Problem](https://en.wikipedia.org/wiki/Monty_Hall_problem)

## Usage

```ruby
require 'monty_hall_problem'

MontyHallProblem::Playground.new(100).play(:change).play(:no_change)
# change - all:100; win:69; lose:31; P(win)=69.0%
# no_change - all:100; win:34; lose:66; P(win)=34.0%

MontyHallProblem::Playground.new(100, door_size: 10, car_size: 1, open_size: 8).play(:change).play(:no_change)
# change - all:100; win:91; lose:9; P(win)=91.0%
# no_change - all:100; win:9; lose:91; P(win)=9.0%
```
