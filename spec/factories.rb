FactoryGirl.define do
  factory :user do
 	name					"Jayant kumar"
	email					"jay@live.com"
	password				"foobar"
	password_confirmation 	"foobar" 	
  end
end

#Factory.define :user do |user|
#	user.name		"Jayant Kumar"
#	user.email		"123@live.com"
#	user.password 	"foobar"
#	user.password_confirmation "foobar"
#end

#FactoryGirl.sequence :email do |n|
#	"person-#{n}@example.com"
#end