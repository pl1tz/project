class CreateAboutCompanies < ActiveRecord::Migration[7.2]
  def change
    create_table :about_companies do |t|
      t.string :description

      t.timestamps
    end
  end
end
