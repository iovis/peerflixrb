FactoryGirl.define do
  factory :kat, class: KAT do
    search 'suits s05e16'
    initialize_with { new(search) }
  end
end
