include RandomData
require 'faker'

member1 = User.create!(
  email: 'member1@example.com',
  password: 'helloworld',
  username: 'member1'
)

member2 = User.create!(
  email: 'member2@example.com',
  password: 'helloworld',
  username: 'member2'
)

10.times do
  name = Faker::Name.name
  username = Faker::Internet.user_name(name)
  User.create!(
    email: Faker::Internet.email(username),
    password: 'helloworld',
    username: username
  )
end

users = User.all

50.times do
  Wiki.create!(
    user: users.sample,
    title: RandomData.random_sentence,
    body: RandomData.random_paragraph
  )
end
