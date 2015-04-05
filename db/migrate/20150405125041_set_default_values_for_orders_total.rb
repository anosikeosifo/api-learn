class SetDefaultValuesForOrdersTotal < ActiveRecord::Migration
  def change
    remove_column :orders, :total
    add_column :orders, :total, :decimal, default: 0.0     
  end
end
