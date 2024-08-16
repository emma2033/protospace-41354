class PrototypesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :edit, :create, :update, :destroy]
  before_action :set_prototype, only: [:edit, :update, :destroy]
  before_action :check_user, only: [:edit, :update, :destroy]
  def index
    @prototypes = Prototype.all
  end

  def new
    @prototype = Prototype.new
  end

  def create
    @prototype = Prototype.new(prototype_params)
    if @prototype.save
      # 保存成功時の処理（リダイレクトなど）
      redirect_to root_path, notice: 'Prototype was successfully created.'
    else
      # 保存失敗時の処理（再表示など）
      render :new
    end
  end

  def show
    @prototype = Prototype.find_by(id: params[:id])
    if @prototype.nil?
      redirect_to root_path, alert: 'プロトタイプが見つかりません。'
    else
      @comment = Comment.new
      @comments = @prototype.comments.includes(:user)
    end
  end

  def edit
    @prototype = Prototype.find(params[:id])
  end

  def update
    @prototype = Prototype.find(params[:id])
      if @prototype.update(prototype_params)
        redirect_to prototype_path(@prototype)
      else
        render :edit
      end
  end

  def destroy
    prototype = Prototype.find(params[:id])
    prototype.destroy
    redirect_to root_path
  end

  private

  def prototype_params
    params.require(:prototype).permit(:title, :catch_copy, :concept, :image).merge(user_id: current_user.id)
  end

  def check_user
    unless @prototype.user == current_user
      redirect_to root_path
    end
  end
end
