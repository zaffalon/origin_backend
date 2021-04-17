class CreatePersonalInformations < ActiveRecord::Migration[6.1]
  def change
    create_table :personal_informations, id: :string, collation: "utf8_bin", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
      t.integer "age"
      t.integer "dependents"
      t.integer "income"
      t.string "marital_status"

      t.datetime "deleted_at", index: true
      t.timestamps
    end
  end
end
