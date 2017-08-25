FactoryGirl.define do

  # date random generator
  sequence :date do |n|
    (0..n).to_a.sample.days.ago.to_date.strftime('%F')
  end

  # email random generator
  sequence :email do |n|
    "test_#{n}@welcome.com"
  end

  factory :driver_session do
    skip_create

    email
    password 'password'

    trait 'as_auth_resource' do
      token '1aMdXpWH7vsbUwfcXnjr'
      attempt_counter 1
    end
  end # of driver factory

  factory :schedule_item do
    skip_create

    date
    transfer_available_from "13:30"
    transfer_available_to "16:30"
    request_available_from "11:30"
    request_available_to "17:30"

    trait :invalid do
      transfer_available_from nil
    end
  end # of schedule_item factory

  factory :schedule do
    skip_create

    items {build_list(:schedule_item, 4)}

    trait :invalid do
      items {build_list(:schedule_item, 4, :invalid)}
    end
  end # of schedule factory

end # of FactoryGirl
