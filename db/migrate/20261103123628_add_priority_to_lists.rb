class AddPriorityToLists < ActiveRecord::Migration[8.1]
  def change
    add_column :lists, :priority, :string, default: "medium"
  end
end
