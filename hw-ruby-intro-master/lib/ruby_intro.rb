# When done, submit this entire file to the autograder.

# Part 1

def sum(arr)
  # YOUR CODE HERE
  arr.reduce(0, :+)
end

def max_2_sum(arr)
  # YOUR CODE HERE
  return 0 if arr.empty?

  # 如果数组只有一个元素，返回该元素
  return arr[0] if arr.size == 1

  # 对数组进行排序并取最后两个元素（即最大的两个元素）
  sorted_arr = arr.sort
  sorted_arr[-1] + sorted_arr[-2]
end

def sum_to_n?(arr, n)
  # YOUR CODE HERE
  # 如果数组为空或只有一个元素，直接返回 false
  return false if arr.empty? || arr.size == 1

  # 使用 combination 方法生成所有可能的两个元素的组合
  arr.combination(2).any? { |a, b| a + b == n }
end

# Part 2

def hello(name)
  "Hello, #{name}"
end

def starts_with_consonant?(s)
  # YOUR CODE HERE
  # 检查字符串是否为空
  return false if s.nil? || s.empty?

  # 获取字符串的第一个字符
  first_char = s[0]

  # 检查第一个字符是否为辅音字母
  !!(first_char =~ /^[bcdfghjklmnpqrstvwxyzBCDFGHJKLMNPQRSTVWXYZ]$/)
end

def binary_multiple_of_4?(s)
  return false if s.nil? || s.empty? || s.match?(/[^01]/)
  s.to_i(2) % 4 == 0
end

# Part 3

class BookInStock
  attr_accessor :isbn, :price

  def initialize(isbn, price)
    raise ArgumentError, "ISBN cannot be empty" if isbn.empty?
    raise ArgumentError, "Price must be greater than zero" if price <= 0

    @isbn = isbn
    @price = price
  end

  def price_as_string
    format("$%.2f", @price)
  end
end
