puts 'Привет! Я программа для расчёта Вашего идеального веса. Для расчёта - мне нужны данные, которые я запрошу ниже ;)'
puts 'Введите, пожалуйста, Ваше имя'
print 'Ваше имя: '
name = gets.chomp

puts 'Введите, пожалуйста, Ваш рост'
print 'Ваш рост: '
growth = gets.chomp.to_i

ideal_weight = (growth - 110) * 1.15

ideal_weight_message = 
  if ideal_weight >= 0
    "Хэй, #{name}, твой идеальный вес равен #{ideal_weight.to_i} кг."
  else
    'Ваш вес уже оптимальный ;)'
  end

puts ideal_weight_message