class Monk < Thor
  include Thor::Actions

  desc "test", "Run all tests"
  def test
    verify_config(:test)

    $:.unshift File.join(File.dirname(__FILE__), "test")

    Dir['test/**/*_test.rb'].each do |file|
      load file unless file =~ /^-/
    end
  end

  desc "benchmark [URL|localhost:4567] [NUM|50]", "Run benchmarks NUM times against URL"
  def benchmark(url = "http://localhost:4567", num = 50)
    exec "bin/benchmark #{url} #{num}"
  end

  desc "stories", "Run user stories."
  method_option :pdf, :type => :boolean
  def stories
    $:.unshift(Dir.pwd, "test")

    ARGV << "-r"
    ARGV << (options[:pdf] ? "stories-pdf" : "stories")
    ARGV.delete("--pdf")

    Dir["test/stories/*_test.rb"].each do |file|
      load file
    end
  end

  desc "start ENV", "Start Monk in the supplied environment"
  def start(env = ENV["RACK_ENV"] || "development")
    verify_config(env)

    exec "env RACK_ENV=#{env} ruby init.rb"
  end

  desc "copy_example EXAMPLE, TARGET", "Copies an example file to its destination"
  def copy_example(example, target = target_file_for(example))
    File.exists?(target) ? return : say_status(:missing, target)
    File.exists?(example) ? copy_file(example, target) : say_status(:missing, example)
  end

  desc "init", "Initialize the environment"
  def init
    require "init"
  end

  desc "migrate VERSION = latest", "Migrates the database"
  def migrate(version = nil)
    invoke :init

    require "sequel/extensions/migration"

    version = version.to_i if version

    puts "Migrating to version #{ version || "<latest>" }"

    Sequel::Migrator.apply(Sequel::Model.db, "db/migrations", version)
  end

  desc "seed [ITEMS]", "Add seed data to the database"
  def seed(items = 1)
    invoke :init

    Item.delete
    Customer.delete
    ShipMethod.delete
    PaymentMethod.delete
    CatalogProduct.delete
    CatalogProductAttribute.delete
    Review.delete
    Question.delete
    Calification.delete
    Site.delete


    Sequel::Model.db.transaction do
      @site = Site.create site_id: "MLA", locale: "es"
      @shipMethod = ShipMethod.create description: "A convenir"
      @paymentMethod = PaymentMethod.create name: "visa", logo: "sarasa"
      @product = CatalogProduct.create name: "Iphone mejor del mundo"
      @attr = CatalogProductAttribute.create key: "Wifi", value: "(802.11b/g)"
      @product.add_catalog_product_attribute(@attr)
      @product.save

      @customer_review = Customer.create nickname: "customerReview", points: 95, qty_calif: 100, email: "customerReview@email.com"
      @review = Review.create title: "Titulo de review", pros: "pros", contras: "contras", customer: @customer_review,
          catalog_product: @product, qty_votes: 10, qty_pos: 5, points: 4, conclusion: "conclusion"

      items.to_i.times do |i|
        @customer = Customer.create nickname: "customer#{i}", points: 95, qty_calif: 100, email: "customer@email.com"
        @customerCalif = Customer.create nickname: "otherCustomer#{i}", points: 95, qty_calif: 100, email: "customer@email.com"

        @item = Item.create title: "iPod touch 32gb 3ra generacion, caja sellada", price: 100, description: "description",
          image: "61826546_3253.jpg", bids_count: 35, site: @site, customer: @customer

        30.times do |j|
          Question.insert item_id: @item.id, question: "pregunta#{j}", question_dt: Time.now, answer: "respuesta#{j}", answer_dt: Time.now
        end

        @calification = Calification.insert customer_id: @customerCalif.id, item_id: @item.id, texto_calif: "todo barbaro", value_calif: 1, fecha: Time.now

        @item.catalog_product = @product
        @item.add_payment_method(@paymentMethod)
        @item.add_ship_method(@shipMethod)
        @item.save


        # 5.times do
        #   Item.create title: "Mac Book Pro 13", price: 10000, description: "description",
        #     image: "image.jpg", bids_count: 35, site: @site, customer: @customer
        # end

        puts @item.id
      end
    end
  end

private

  def self.source_root
    File.dirname(__FILE__)
  end

  def target_file_for(example_file)
    example_file.sub(".example", "")
  end

  def verify_config(env)
    verify "config/settings.example.yml"
    verify "config/redis/#{env}.example.conf"
  end

  def verify(example)
    copy_example(example) unless File.exists?(target_file_for(example))
  end

end
