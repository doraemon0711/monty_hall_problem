# frozen_string_literal: true

require_relative "monty_hall_problem/version"

module MontyHallProblem
  class Error < StandardError; end
  class Host
    def initialize(doors, car_size=1)
      @doors = doors
      @car_size = car_size
    end

    def put_cars
      @car_size.times do
        loop do
          break if @doors.put(rand(@doors.size))
        end
      end
    end

    def open_wronth_door(idx, open_size = 1)
      idxs = (@doors.no_car_door_idx - Array(idx)).sample(open_size)
      @doors.opened_door_idx += idxs unless idxs.empty?
      idxs
    end

    def make_known(idx)
      @doors.door[idx]
    end
  end

  class Player
    def initialize(doors)
      @doors = doors
    end

    def choose_door
      rand(@doors.size)
    end

    def change_door(choosed_door_idx)
      (Array.new(@doors.size) { |i| i } - (@doors.opened_door_idx + Array(choosed_door_idx))).sample || choosed_door_idx
    end
  end

  class Doors
    attr_accessor :size
    attr_accessor :door
    attr_accessor :opened_door_idx

    def initialize(size=3)
      self.size = size
      self.door = Array.new(size) { false }
      self.opened_door_idx = []
    end

    def put(door_idx)
      if door[door_idx]
        return false
      else
        door[door_idx] = true
        return true
      end
    end

    def car_door_idx
      door.map.with_index{ |e, i| i if !!e  }.compact
    end

    def no_car_door_idx
      door.map.with_index{ |e, i| i if !e  }.compact
    end
  end

  class Playground
    attr_accessor :times

    def initialize(times, door_size: 3, car_size: 1, open_size: 1)
      self.times = times
      @door_size = door_size
      @car_size = car_size
      @open_size = open_size
    end

    def play_change
      doors = Doors.new(@door_size)
      host = Host.new(doors, @car_size)
      player = Player.new(doors)

      host.put_cars
      idx = player.choose_door
      host.open_wronth_door(idx, @open_size)
      idx = player.change_door(idx)
      host.make_known(idx) ? :win : :lose
    end

    def play_no_change
      doors = Doors.new(@door_size)
      host = Host.new(doors, @car_size)
      player = Player.new(doors)

      host.put_cars
      idx = player.choose_door
      host.open_wronth_door(idx, @open_size)
      host.make_known(idx) ? :win : :lose
    end

    def play(mode)
      result = self.times.times.map do
        mode == :change ? play_change : play_no_change
      end

      win_count = result.count { |e| e == :win }
      lose_count = result.count { |e| e == :lose }
      puts "#{mode} - all:#{self.times}; win:#{win_count}; lose:#{lose_count}; P(win)=#{(win_count.to_f/self.times.to_f * 100).round(2)}%"
      self
    end
  end
end
