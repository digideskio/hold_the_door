Account.create!(
  email:   'admin@site.com',
  name:     FFaker::Name.name,
  company:  FFaker::Company.name,
  address:  FFaker::Address.street_address,
  password: 'qwerty',
  password_confirmation: 'qwerty'
)

puts 'Admin created'

5.times do
  Account.create!(
    email:    FFaker::Internet.email,
    name:     FFaker::Name.name,
    company:  FFaker::Company.name,
    address:  FFaker::Address.street_address,
    password: 'qwerty',
    password_confirmation: 'qwerty'
  )
end

puts 'Users created'

Account.all.each do |account|
  10.times do
    Page.create!(
      account: account,
      title:   FFaker::Lorem.sentence,
      content: FFaker::Lorem.sentences(5)
    )
  end
end

puts 'Posts created'
