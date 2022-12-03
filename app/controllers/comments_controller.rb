class CommentsController < ApplicationController
  include ActionView::Helpers::DateHelper

  before_action :authenticate_user!
  before_action :set_comment, only: [:edit, :update, :destroy]
  before_action :set_user, only: [:create, :new]
  before_action :set_section
  before_action :permitted_to_comment, except: :index
  before_action :ensure_admin!, only: [:edit, :update, :destroy]

  def index
    @comments = @section.comments.order(created_at: :desc)
    respond_to do |format|
      format.html
      format.js { render layout: false }
    end
  end

  # GET /comments/new
  def new
    @comment = Comment.new(section: @section, user: @comment_user)
  end

  # GET /comments/1/edit
  def edit
  end

  # POST /comments
  # POST /comments.json
  def create
    @comment = Comment.new(comment_params)

    respond_to do |format|
      if @comment.save
        NewCommentWorker.perform_async(@comment.id)
        User.active.each do |user|
          @comment.broadcast_prepend_later_to("new_comment_#{user.id}_notification", target: "notifications", partial: "comments/recent_comment", locals: { recent_comment: @comment, current_user: }) if user.show_alerts(@comment.section.department)
        end
        format.html { redirect_to sections_url, notice: t(".success") }
        format.json { render :show, status: :created, location: @comment }
        format.js { flash.now[:notice] = 'Comment was successfully created.' }
      else
        format.html { render :new }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
        format.js { render js: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to section_comment_url, notice: t(".success") }
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @comment.destroy
    @section.broadcast_update_later_to("comment_preview", target: "most_recent_comment_#{@section.id}", partial: "sections/comment_preview", locals: { section: @section })
    respond_to do |format|
      format.html { redirect_to section_comments_url, notice: t(".success") }
      format.js { flash.now[:notice] = 'Comment deleted.' }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_comment
    @comment = Comment.find(params[:id])
  end

  def set_user
    @comment_user = current_user
  end

  def set_section
    @section = Section.find(params[:section_id])
  end

  def permitted_to_comment
    unless current_user.active? || current_user.try(:admin?)
      redirect_to sections_path, notice: t(".permitted_to_comment.inactive")
      return false
    end
  end

  # Never trust parameters from the scary internet, only allow the permit list through.
  def comment_params
    params.require(:comment).permit(:user_id, :section_id, :body, :section_id)
  end
end
