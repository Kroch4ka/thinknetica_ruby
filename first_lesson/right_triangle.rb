puts 'Привет! Я программа для определения характеристики треугольника. Для расчёта - мне нужны данные, которые я запрошу ниже ;)'

puts 'Введите, пожалуйста, стороны a b c треугольника. После ввода каждой стороны - нажимайте на enter.'
a, b, c = gets.chomp.to_i, gets.chomp.to_i, gets.chomp.to_i

is_equilateral = a == b && b == c
is_isosceles = (a == b && a != c) || (a == c && a != b) || (b == c && a != b)
is_rectangular = false

unless is_equilateral && is_isosceles
  hypotenuze, first_side, second_side = 
    if a > b && a > c
      [a, b, c]
    elsif b > a && b > c
      [b, a, c]
    elsif c > a && c > b
      [c, a, b]
    end

  is_rectangular = first_side ** 2 + second_side ** 2 == hypotenuze ** 2 
end

equilateral_message = 'Эй, это ведь равносторонний треугольник!'
isosceles_message = 'Эй, это ведь равнобедренный треугольник!'
rectangular_message = 'Эй, это ведь прямоугольный треугольник!'
undefined_message = 'Очень странный треугольник. Не могу определить его характеристику('

message = 
  if is_isosceles
    isosceles_message
  elsif is_equilateral
    equilateral_message
  elsif is_rectangular
    rectangular_message
  else
    undefined_message
  end

puts message
