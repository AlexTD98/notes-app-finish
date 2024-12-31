# db/seeds.rb

# Generar 200 notas con datos aleatorios
200.times do |i|
  Note.create!(
    title: "Note #{i + 1}",
    body: "This is the body of note number #{i + 1}. It contains random text to make it unique.",
    created_at: Faker::Time.backward(days: rand(1..365), period: :all),  # Genera una fecha aleatoria
    updated_at: Faker::Time.backward(days: rand(1..365), period: :all)
  )
end
