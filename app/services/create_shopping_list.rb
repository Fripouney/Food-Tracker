class CreateShoppingList
  attr_reader :name, :ingredient_params

  def initialize(name, ingredient_params=[])
    @name = name
    @ingredient_params = ingredient_params
  end

  def call
    ingredient_check = check_ingredients
    return { status: :error, message: 'invalid_ingredient_list' } unless ingredient_check
    list = ShoppingList.create(name:, done: false)
    list.ingredients.insert_all(ingredient_params)
    list
  end

  private

  def check_ingredients
    true
  end
end

