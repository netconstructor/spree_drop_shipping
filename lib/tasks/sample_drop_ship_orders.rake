namespace :db do
  namespace :sample do
    desc "Create sample drop ship orders"
    task :drop_ship_orders => :environment do
    
      if Order.count == 0
        puts "Please run `rake db:sample` first to create products and orders" 
        exit
      end
      
      if Supplier.count == 0
        puts "Please run `rake db:sample:suppliers` first to create suppliers" 
        exit
      end
      
      count      = 0
      @orders    = Order.complete.includes(:line_items).all
      @suppliers = Supplier.all
      
      puts "Linking existing line items to suppliers"
      LineItem.where("supplier_id IS NULL").all.each do |li|
        print "*" if li.update_attributes(:supplier_id => @suppliers.shuffle.first.id)
      end
      puts
      
      puts "Creating drop ship orders for existing orders"
      Order.all.each do |order|
	      print "*" if order.finalize_for_dropship!
      end
      puts 
      
    end  
  end
end
