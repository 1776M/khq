module Enumerable

  def sum_it
    return self.inject(0){|acc,i|acc +i}
  end

  def mean_it
    self.sum_it/self.length.to_f
  end

  def sample_variance
      m = self.mean_it
      sum_it = self.inject(0){|accum, i| accum +(i-m)**2 }
      sum_it/(self.length - 1).to_f
  end

  def standard_deviation_it
      return Math.sqrt(self.sample_variance)
  end

  def calculate_percentile(percentile)
      self.sort[(percentile * self.length).ceil - 1]
  end

end