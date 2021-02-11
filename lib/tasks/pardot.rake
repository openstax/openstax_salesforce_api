require 'update_lists_from_pardot'

namespace :pardot do
	desc 'Update lists from Pardot'
	task 'update_lists' => :environment do
		puts "update_lists task: started"
		UpdateListsFromPardot.call
		puts "update_lists task: completed"
	end
end
