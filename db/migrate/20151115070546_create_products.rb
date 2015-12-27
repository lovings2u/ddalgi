class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|

    	t.string :prod_image #상품이미지
    	t.integer :prod_id #상품 id
    	t.integer :prod_price #상품가격
    	t.integer :total_sales #총 판매금액
    	t.integer :total_volume #총 판매량

      t.timestamps null: false
    end
  end
end
