
namespace :db do

  desc 'populate leads'
  task populate: :environment do

    Lead.destroy_all

    def random_status
      ['new', 'in progress', 'closed', 'bad'].sample
    end

    20.times do
      Lead.create(
        first_name: FFaker::Name.first_name,
        last_name: FFaker::Name.last_name,
        email: FFaker::Internet.email,
        phone: FFaker::PhoneNumber.phone_number,
        status: random_status,
        notes: FFaker::HipsterIpsum.words(10).join(' ')
      )
    end

  end
end
