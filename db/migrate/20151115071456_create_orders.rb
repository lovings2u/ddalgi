class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|

      t.string :order_index #주문번호
      t.string :progress #주문상태
      t.string :prod_index #주문상품 번호
      t.integer :prod_volume #상품 주문개수
      t.integer :prod_price #상품 주문금액
      t.string :address #구매자 주소
      t.string :detail_address #구매자 상세주소
      t.date :order_date #구매일자
      t.integer :customer_id #구매자 번호
      t.integer :product_id #상품번호
      t.string :phone_number #핸드폰번호
      t.string :customer_name #구매자 이름
      t.date :delivery_date #발송일자
      t.string :present_message #선물 메시지
      t.string :present_number #선물 메시지 받는사람 번호


      t.timestamps null: false
    end
  end
end
