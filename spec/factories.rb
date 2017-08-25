FactoryGirl.define do

  # date random generator
  sequence :date do |n|
    (0..n).to_a.sample.days.ago.to_date
  end

  # email random generator
  sequence :email do |n|
    "test_#{n}@welcome.com"
  end

  factory :driver_session do
    skip_create

    email
    password 'password'
  end # of driver factory

end # of FactoryGirl
