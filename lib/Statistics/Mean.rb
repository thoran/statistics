# Statistics/Mean.rb
# Statistics::Mean

module Statistics
  module Mean
    module_function

    def of(values)
      floats = values.map(&:to_f)
      floats.sum / floats.size
    end
  end
end
