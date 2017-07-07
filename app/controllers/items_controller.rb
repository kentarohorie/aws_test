class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :update, :destroy]
  # before_action http_basic_authenticate_with name: "username", password: "passwd123"
  before_action :basic_auth, only: :secret

  def root
    render text: "AMAZON"
  end

  def secret
    render text: "SUCCESS"
  end

  def calc
    binding.pry
  end

  def stocker
    if params[:function] == "addstock"
      amount = params[:amount] ? params[:amount] : 1
      Item.create(name: params[:name], amount: amount)
    elsif params[:function] == "checkstock"
      item = Item.where(name: params[:name]).order("name ASC")
      if item.empty?
        render json: Item.all.order("name ASC")
      else
        render json: item
      end
    elsif params[:function] == "sell"
      item = Item.find_by_name(params[:name])
      if params[:amount]
        amount = params[:amount].to_i
      else
        amount = 1
      end
      item.amount -= amount
      item.save
      if params[:price] && params[:price].to_i > 0
        item.sells.create(amount: amount, price: params[:price].to_i)
      end
    elsif params[:function] == "checksales"
      sells = Sell.all.map { |s| s.price * s.amount }.inject(:+)
      render text: "sales: #{ sells }"
    else
      render text: "no"
    end
  end

  # GET /items
  def index
    @items = Item.all

    render json: @items
  end

  # GET /items/1
  def show
    render json: @item
  end

  # POST /items
  def create
    @item = Item.new(item_params)

    if @item.save
      render json: @item, status: :created, location: @item
    else
      render json: @item.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /items/1
  def update
    if @item.update(item_params)
      render json: @item
    else
      render json: @item.errors, status: :unprocessable_entity
    end
  end

  # DELETE /items/1
  def destroy
    @item.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def item_params
      params.fetch(:item, {})
    end

    def basic_auth
      authenticate_or_request_with_http_basic do |user,pass|
        user == "amazon" && pass = "candidate"
      end
    end
end
