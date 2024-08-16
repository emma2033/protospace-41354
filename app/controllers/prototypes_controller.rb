class PrototypesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :edit, :create, :update, :destroy]
  before_action :set_prototype, only: [:edit, :update, :show, :destroy]
  before_action :move_to_index, only: [:edit, :update, :destroy]
  def index
    @prototypes = Prototype.all
  end

  def new
    @prototype = Prototype.new
  end

  def create
    @prototype = Prototype.new(prototype_params)
    if @prototype.save
      redirect_to root_path, notice: 'Prototype was successfully created.'
    else
      render :new
    end
  end

  def show
    if @prototype.nil?
      redirect_to root_path, alert: 'プロトタイプが見つかりません。'
    else
      @comment = Comment.new
      @comments = @prototype.comments.includes(:user)
    end
  end

  def edit
  end

  def update
      if @prototype.update(prototype_params)
        redirect_to prototype_path(@prototype)
      else
        render :edit
      end
  end

  def destroy
    @prototype.destroy
    redirect_to root_path
  end

  private

  def prototype_params
    params.require(:prototype).permit(:title, :catch_copy, :concept, :image).merge(user_id: current_user.id)
  end

  def set_prototype
    @prototype = Prototype.find(params[:id])
  end

  def move_to_index
    unless user_signed_in? && @prototype.user == current_user
      redirect_to root_path
    end
  end
end
