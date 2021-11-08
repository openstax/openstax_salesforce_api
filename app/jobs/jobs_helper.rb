class JobsHelper
  def self.delete_objects_not_in_salesforce(name, sf_objs)
    name.constantize.where.not(salesforce_id: sf_objs.map(&:id)).destroy_all
  end
end
