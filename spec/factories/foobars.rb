FactoryGirl.define do

  factory :foo_fixed, class: 'Foo' do
    name "test"
  end

  factory :foo_sequence, class: 'Foo' do
    sequence(:name) { |n| "test#{n}" }
  end

  factory :foo_names, :parent=>:foo_fixed do
    sequence(:name) { |n| ["larry", "moe", "curly"][n% 3] }
  end

  factory :foo_transient, class: 'Foo' do
    name "test"
    transient do
      male true
    end

    after(:build) do |object, props|
      object.name = props.male ? "Mr Test" : "Ms Test"
    end
  end

  factory :foo_faker, class: 'Foo' do
    name { Faker::Name.name }
  end

  factory :foo_ctor, class: 'Foo' do
    transient do
      hash {}
    end
    initialize_with { Foo.new(hash) }
  end

  factory :foo, :parent=>:foo_faker do
  end

  factory :bar_faker, class: 'Bar' do
    name { Faker::Team.name.titleize }
  end

  factory :bar, :parent=>:bar_faker, class: 'Bar' do
  end
end
