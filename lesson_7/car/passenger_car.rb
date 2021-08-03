class PassengerCar < TrainCar

  CAR_TYPE = "passenger"

  def initialize(number_of_seats)
    @numbers_of_seats = number_of_seats
    @number_of_occupied_seats = 0
    super(CAR_TYPE)
  end

  def take_the_seat
    increase_number_of_occupied_seats
  end

  def number_free_seats
    diff_occupied_and_free_seats
  end

  private

  attr_accessor :numbers_of_seats, :number_of_occupied_seats

  def increase_number_of_occupied_seats
    self.number_of_occupied_seats += 1
  end

  def diff_occupied_and_free_seats
    self.numbers_of_seats - self.number_of_occupied_seats
  end
end