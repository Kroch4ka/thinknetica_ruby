puts 'Привет! Я программа для решения квадратного уравнения! Пожалуйста, введите данные которые я запрошу ниже ;)'

puts 'Введите, пожалуйста, коэффициент a'
print 'Коэффициент a: '

a = gets.chomp.to_i

puts 'Введите, пожалуйста, коэффициент b'
print 'Коэффициент b: '

b = gets.chomp.to_i

puts 'Введите, пожалуйста, коэффициент c'
print 'Коэффициент c: '

c = gets.chomp.to_i

discriminant = b ** 2 - (4 * a * c)

roots = 
  if discriminant >= 0
    x1 = (-b + Math.sqrt(discriminant)) / (2 * a)
    x2 = (-b - Math.sqrt(discriminant)) / (2 * a)
    [x1, x2]
  else
    []
  end

have_roots_message = "Хэй, имеются 2 решения: #{roots.join(' и ')}"
no_roots_message = "Хэй, к сожалению решений нет("

message = roots.length == 0 ? no_roots_message : have_roots_message

puts message