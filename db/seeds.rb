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
  User.create!(
    email: Faker::Internet.email,
    password: 'helloworld'
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
