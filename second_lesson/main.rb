def leap_year?(year)
  raise 'Not given fixnum instance in leap_year? func' unless year.instance_of? Fixnum
  return false if year % 4 != 0
  return year % 100 != 0 || year % 400 == 0
end

def fib(num)
  return 0 if num == 1
  return 1 if num == 2

  fib(num - 1) + fib(num - 2)
end

def get_arr_with_fib_sequence(limit_num = 100)
  result = []
  fib_elem = 1

  while ((elem = fib(fib_elem)) <= limit_num)
    result << elem
    fib_elem += 1
  end

  result
end

#1
months = {
  1 => 31,
  2 => 28,
  3 => 31,
  4 => 30,
  5 => 31,
  6 => 30,
  7 => 31,
  8 => 31,
  9 => 30,
  10 => 31,
  11 => 30,
  12 => 31
}

months.each do |month, count_days|
  puts month if count_days == 30
end

#2
(10..100).step(5).to_a

#3
puts get_arr_with_fib_sequence

#4
result = ('a'..'z')
  .each_with_index
  .each_with_object({}) do |(letter, idx), hash|
    (hash[letter.to_sym] = idx + 1) unless (letter =~ /[aeoiuy]/).nil?
  end


#5

puts 'Введите, пожалуйста, число'
day = gets.chomp.to_i

puts 'Введите, пожалуйста, месяц'
month = gets.chomp.to_i

puts 'Введите, пожалуйста, год'
year = gets.chomp.to_i

result = 0
current_month = 1
leap_year_increment = leap_year?(year) ? 1 : 0

while month > current_month
  result += months[current_month]
  current_month += 1
end

result += day + leap_year_increment

puts "Порядковы номер: #{result}"
#6

def get_price_title
  puts 'Введите, пожалуйста, название товара'
  print 'Название: '
  product_title = gets.chomp
end

def get_unit_price
  puts 'Введите, пожалуйста, цену за единицу товара'
  print 'Цена за единицу: '
  unit_price = gets.chomp.to_f
end

def get_total_amount
  puts 'Введите, пожалуйста, количество купленного товара'
  print 'Количество: '
  total_amout = gets.chomp.to_f
end

def get_sum_by_product_detail(product_detail)
  product_detail[:amount] * product_detail[:price]
end

def get_total_sum(products)
  products.reduce(0) { |accum, (_, detail)| accum += get_sum_by_product_detail(detail) }
end

STOP_WORD = 'стоп'
stop_message = "Если Вы хотите выйти из режима ввода, то введите, пожалуйста: #{STOP_WORD}. Для продолжения нажмите Enter!"

products = {}

loop do

  title = get_price_title
  price = get_unit_price
  amount = get_total_amount

  products[title] = {
    price:,
    amount:
  }

  puts stop_message
  break if gets.chomp.downcase == STOP_WORD
end

products.each do |title, detail|
  puts "Сумма по товару #{title} равна #{get_sum_by_product_detail(detail)}"
end

puts "Общая сумма равна: #{get_total_sum(products)}"