require('minitest/autorun')
require('minitest/reporters')
Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

require_relative('../pub')
require_relative('../drink')
require_relative('../customer')

class TestPub < Minitest::Test
    def setup()
        @customer = Customer.new("Dougal", 100, 40)
        @drink1 = Drink.new("Red Hat", 5, 8)
        @drink2 = Drink.new("Cats Tail", 3, 3)
        @drinks = [@drink1, @drink2]
        @pub = Pub.new("Bjorks House", 150, @drinks)
    end

    def test_get_name()
        assert_equal("Bjorks House", @pub.name)
    end

    def test_get_till_balance()
        assert_equal(150, @pub.till)
    end

    def test_start_with_2_drinks()
        assert_equal(2, @pub.drinks.count())
    end

    def test_check_underage__true()
        underage_customer = Customer.new("Dougal", 100, 16)
        assert_equal(true, @pub.is_underage?(underage_customer.age))
    end

    def test_check_underage__false()
        customer_of_age = Customer.new("Dougal", 100, 18)
        assert_equal(false, @pub.is_underage?(customer_of_age.age))
    end

    def test_refuse_service__customer_drunk
        @customer.increase_drunkeness(@drink1.alcohol_level)
        @customer.increase_drunkeness(@drink1.alcohol_level)
        @customer.increase_drunkeness(@drink1.alcohol_level)
        @customer.increase_drunkeness(@drink1.alcohol_level)
        @customer.increase_drunkeness(@drink1.alcohol_level)
        assert_equal(true, @pub.refuse_service(@customer.drunkeness_level))
    end

    def test_refuse_service__customer_not_drunk
        @customer.increase_drunkeness(@drink1.alcohol_level)
        assert_equal(false, @pub.refuse_service(@customer.drunkeness_level))
    end

    def test_refuse_to_sell_drink_if_customer_is_drunk()
        @customer.increase_drunkeness(@drink1.alcohol_level)
        @customer.increase_drunkeness(@drink1.alcohol_level)
        @customer.increase_drunkeness(@drink1.alcohol_level)
        @customer.increase_drunkeness(@drink1.alcohol_level)
        @customer.increase_drunkeness(@drink1.alcohol_level)
        assert_equal(true, @pub.sell_drink(@drink1, @customer))
    end

    def test_sell_drink_when_not_drunk
        @pub.sell_drink(@drink1, @customer)
        assert_equal(1, @drinks.count)
        assert_equal(95, @customer.wallet)
        assert_equal(155, @pub.till)
        assert_equal(8, @customer.drunkeness_level)
    end
end